//
//  InitializationWorker.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import Foundation
import UIKit
import SwiftSoup
import FirebaseFirestore

typealias responseHandlerInitialization = (_ response: InitializationModel.Fetch.Response) ->()
typealias responseHandlerIFIX = (_ response: InitializationModel.FetchIFIX.Response) ->()

class InitializationWorker {
    init() {
        ConfigureDataBase.instance.clearPersistence()
    }
    
    func fetch(complete:@escaping(responseHandlerListFII)) {
        UserDefaults.standard.removeObject(forKey: "listFiis")
        ListFii.getListLocal()
        if ListFii.listFiis.isEmpty {
            ConfigureDataBase.instance.collection(ConfigureDataBase.collectionFiis).whereField("active", in: [true]).getDocuments { querySnapshot, error in
                if error == nil {
                    for document in querySnapshot!.documents {
                        let obj = document.data()
                        ListFii.listFiis.append(.init(socialReason: obj["socialReason"] as? String
                                                      , name: obj["name"] as? String
                                                      , code: obj["code"] as? String
                                                      , segment: obj["segment"] as? String
                                                      , price: obj["price"] as? String
                                                      , earnings: obj["earnings\(Util.currentYear)"] as? [String:[String:Any]]
                                                      , dividendYield: obj["dividendYield"] as? String
                                                      , equityValue: obj["equityValue"] as? String
                                                      , numberShares: obj["numberShares"] as? Int
                                                      , phone: obj["phone"] as? String
                                                      , site: obj["site"] as? String
                                                      , social_network: obj["social_network"] as? ([String:String])
                                                      , hrefReport: obj["hrefReport"] as? String
                                                      , isIFIX: obj["isIFIX"] as? Bool
                                                      , objective: obj["objective"] as? String
                                                     ))
                    }
                    if !ListFii.listFiis.isEmpty {
                        ListFii.saveLocal()
                        complete(ListFii.listFiis)
                    } else {
                        complete([FIIModel.Fetch.FII.init()])
                    }
                } else {
                    complete([FIIModel.Fetch.FII.init()])
                }
            }
        } else {
            complete(ListFii.listFiis)
        }
    }
    
    func fetchQuotes(complete:@escaping(responseDone)) {
        let sheet: String = (Bundle.main.infoDictionary?["QuotationWorksheet"] ?? "") as! String
        let url = URL(string: sheet)
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            if error != nil {
                return
            }
            let html = String(data: data!, encoding: .utf8)!
            do {
                let doc: Document = try SwiftSoup.parse(html)
                let tr = try doc.select("tr")
                
                for i in 2..<tr.count {
                    let x = try tr[i].select("td")[1].text()
                    let y = Double(try tr[i].select("td")[1].text().replacingOccurrences(of: "R$ ", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: ",", with: ".")) ?? 0.0
                    if  (x == "#N/D" || y <= 0.0) ? false : true {
                        
                        var closings: [(month: Int, price:String)] = .init()
                        for x in 8...19 {
                            closings.append((month: x-7, price: try tr[i].select("td")[x].text()))
                        }
                        
                        quoteList.append(.init(code: try tr[i].select("td").first()!.text()
                                               , currentPrice: try tr[i].select("td")[1].text()
                                               , opening: try tr[i].select("td")[2].text().replacingOccurrences(of: "R$", with: "")
                                               , variation: try tr[i].select("td")[3].text().replacingOccurrences(of: "R$", with: "")
                                               , minimum: try tr[i].select("td")[4].text().replacingOccurrences(of: "R$", with: "")
                                               , maximum: try tr[i].select("td")[5].text().replacingOccurrences(of: "R$", with: "")
                                               , closingPrevious: try tr[i].select("td")[6].text().replacingOccurrences(of: "R$", with: "")
                                               , numberShares: Int(try tr[i].select("td")[7].text()) ?? 0
                                               , closing: closings
                                              ))
                    }
                }
                complete(true)
            } catch Exception.Error(type: let type, Message: let message) {
                print("Erro aqui: \(type) / \(message)")
                complete(false)
            } catch {
                print("erro")
                complete(false)
            }
        }
        task.resume()
    }
    
    func fetchIFIX(success:@escaping(responseHandlerIFIX), fail:@escaping(responseHandlerIFIX)) {
        let url = URL(string: InitializationModel.FetchIFIX.Request.init().url)
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            if error != nil {
                return
            }
            let html = String(data: data!, encoding: .utf8)!
            do {
                let doc: Document = try SwiftSoup.parse(html)
                let obj = try doc.getElementsByClass("col-12 col-lg-8 order-2 order-lg-1").first()
                let pontosIFIX = try obj!.getElementsByClass("value").first()?.text()
                let percent = try obj!.getElementsByClass("percentage").first()?.text()
                let min = try obj!.getElementsByClass("minimo").first()?.text()
                let max = try obj!.getElementsByClass("maximo").text()
                let dataAtu = try obj!.getElementsByClass("date-update").text()
                
                let ifix = InitializationModel.FetchIFIX.IFIX(points: pontosIFIX, percent: percent, minimum: min, maximum: max, dateUpdate: dataAtu)
                InitializationModel.dataIfix = ifix
                success(.init(object: ifix, isError: false, message: nil))
            } catch Exception.Error(type: let type, Message: let message) {
                print("Erro aqui: \(type) / \(message)")
                InitializationModel.dataIfix = nil
                fail(.init(object: nil, isError: true, message: "Erro ao baixar dados do IFIX"))
            } catch {
                print("erro")
                InitializationModel.dataIfix = nil
                fail(.init(object: nil, isError: true, message: "Erro ao baixar dados do IFIX"))
            }
        }
        task.resume()
    }
    
    func fetchIndexes() {
        let request = InitializationModel.FetchIndexes.Request()
        var obj = InitializationModel.FetchIndexes.Indexes()
        MarketIndex.allCases.forEach({ item in
            let url = URL(string: "\(request.url)\(item.rawValue)")
            let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
                if error != nil {
                    return
                }
                let html = String(data: data!, encoding: .utf8)!
                do {
                    let doc: Document = try SwiftSoup.parse(html)
                    
                    if item == .selic {
                        if let rows = try doc.getElementsByClass("small-6 large-centered columns holder-valor").first() {
                            let today = try doc.getElementsByClass("small-6 large-centered columns holder-valor").select("input").attr("value")
                            let currentMonth = try rows.getElementById("select-selic-mes")?.select("option").first()?.attr("value") ?? "0,0%"
                            let yearCurrently = try rows.getElementById("select-selic-ano")?.select("option").first()?.attr("value") ?? "0,0%"
                            let year = try rows.getElementById("select-selic-ano")?.select("option").first()?.text() ?? "9999"
                            let annualGoal = (try rows.getElementById("selic-ano-meta")?.attr("value") ?? "0,0%").replacingOccurrences(of: " ", with: "")
                            obj.selic = (today: today.isEmpty ? "0,0%" : today, currentMonth: currentMonth, yearCurrently: yearCurrently, annualGoal: (year: year, value: annualGoal))
                        }
                    } else {
                        let rows = try doc.getElementsByClass("small-6 large-centered columns").first()?.getElementsByClass("row")
                        if let lines = rows {
                            let x = try lines[1].getElementById("select-mes")?.select("option")
                            var months = [[String:String]]()
                            for i in 0..<12 {
                                months.append([try x?[i].attr("aria-label") ?? "": try x?[i].attr("value") ?? ""])
                            }
                            let result = (twelveMonths: try lines[0].select("input").attr("value")
                                          ,months: months
                                          ,currentYear: try lines[2].getElementById("inp-ano")?.attr("value") ?? "")
                            
                            switch item {
                            case .ipca:
                                obj.ipca = result
                            case .igpm:
                                obj.igpm = result
                            case .inpc:
                                obj.inpc = result
                            case .cdi:
                                obj.cdi  = result
                            default:
                                break
                            }
                        }
                        
                    }
                    InitializationModel.dataIndexes = obj
                    
                } catch Exception.Error(type: let type, Message: let message) {
                    print("Erro aqui: \(type) / \(message)")
                    
                } catch {
                    print("erro")
                }
            }
            task.resume()
        })
    }
    
    func fetchNewOrUpdatedItem(complete:@escaping(responseHandlerArrayOfTuple)) {
        var list = [(ItemsLibrary,Bool)]()
        fetchGlossary { response in
            fetchBooks { response in
                fetchCourses { response in
                    fetchBrokers { response in
                        fetchTax { response in
                            complete(list)
                        }
                    }
                }
            }
        }
        
        func fetchGlossary(complete:@escaping(responseDone)) {
            ConfigureDataBase.instance.collection(ConfigureDataBase.collectionGlossary).getDocuments { querySnapshot, error in
                if error == nil {
                    for document in querySnapshot!.documents {
                        if document.data()["new"] as? Bool ?? false || document.data()["updated"] as? Bool ?? false {
                            list.append((.glossary, true))
                            complete(true)
                            break
                        }
                    }
                    complete(false)
                } else {
                    complete(false)
                }
            }
        }
        
        func fetchBooks(complete:@escaping(responseDone)) {
            ConfigureDataBase.instance.collection(ConfigureDataBase.collectionBooks).getDocuments { querySnapshot, error in
                if error == nil {
                    for document in querySnapshot!.documents {
                        if document.data()["new"] as? Bool ?? false || document.data()["updated"] as? Bool ?? false {
                            list.append((.books, true))
                            complete(true)
                            break
                        }
                    }
                    complete(false)
                } else {
                    complete(false)
                }
            }
        }
        
        func fetchCourses(complete:@escaping(responseDone)) {
            ConfigureDataBase.instance.collection(ConfigureDataBase.collectionCourses).getDocuments { querySnapshot, error in
                if error == nil {
                    for document in querySnapshot!.documents {
                        if document.data()["new"] as? Bool ?? false || document.data()["updated"] as? Bool ?? false {
                            list.append((.courses, true))
                            complete(true)
                            break
                        }
                    }
                    complete(false)
                } else {
                    complete(false)
                }
            }
        }
        
        func fetchBrokers(complete:@escaping(responseDone)) {
            ConfigureDataBase.instance.collection(ConfigureDataBase.collectionBrokers).getDocuments { querySnapshot, error in
                if error == nil {
                    for document in querySnapshot!.documents {
                        if document.data()["new"] as? Bool ?? false || document.data()["updated"] as? Bool ?? false {
                            list.append((.brokers, true))
                            complete(true)
                            break
                        }
                    }
                    complete(false)
                } else {
                    complete(false)
                }
            }
        }
        
        func fetchTax(complete:@escaping(responseDone)) {
            ConfigureDataBase.instance.collection(ConfigureDataBase.collectionTax).getDocuments { querySnapshot, error in
                if error == nil {
                    for document in querySnapshot!.documents {
                        if document.data()["new"] as? Bool ?? false || document.data()["updated"] as? Bool ?? false {
                            list.append((.tax, true))
                            complete(true)
                            break
                        }
                    }
                    complete(false)
                } else {
                    complete(false)
                }
            }
        }
    }
    
    func fetchUserData(complete:@escaping(responseDone)) {
        let ref = ConfigureDataBase.instance.collection(ConfigureDataBase.collectionUser).document(DataUser.email ?? "")
        ref.getDocument { document, error in
            if let document = document, document.exists {
                
                if let vip = document.data()!["vip_in"] as? Timestamp {
                    UserDefaultKeys.vip.setValue(value: true)
                    DataUser.vip = Calendar.current.dateComponents([.day], from: vip.dateValue(), to: Date()).day!
                    complete(true)
                } else {
                    UserDefaultKeys.vip.setValue(value: false)
                    complete(true)
                }
                DataUser.gender = document.data()!["gender"] as? String
                UserDefaultKeys.lifetime.setValue(value: document.data()?["lifetime"] as? Bool ?? false)
                ReportModel.patrimony = ReportModel.Fetch.Report(patrimony: document.data()?[ConfigureDataBase.fieldPatrimony] as? [String:[String:Double]] ?? [Util.currentYear:["":0]])
            } else {
                complete(false)
            }
        }
    }
    
    func fetchInBaseDataInboxMessages(complete:@escaping(responseHandlerSentMessages)) {
        var receiveds = [UserInboxModel.Fetch.Message]()
        ConfigureDataBase.instance.collection(ConfigureDataBase.collectionUser).document(DataUser.email?.lowercased() ?? "").collection(ConfigureDataBase.collectionUserMessage).whereField(ConfigureDataBase.fieldTypeMessage, in: [TypeMessage.received.rawValue]).getDocuments { querySnapshot, error in
            if error == nil {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    receiveds.append(.init(
                        idBD: document.documentID
                        , idLocal: ""
                        , owner: InitializationModel.systemName
                        , date: (data["inserted_in"] as! Timestamp).dateValue().convertToDatePtBr()
                        , title: "re: \(NSLocalizedString((data["typeTitle"] as! String).lowercased(), comment: "").firstLetterUppercased())"
                        , description: data["message"] as! String
                        , typeMessage: .received
                        , read: (data["read"] as? Bool) ?? false
                    ))
                }
            }
            UserDefaultKeys.unread_message.setValue(value: receiveds.contains(where: { $0.read == false }))
            complete(receiveds)
        }
    }
    
    func fetchBasicSalary() {
        let ref = ConfigureDataBase.instance.collection(ConfigureDataBase.collectionParameters).document(ConfigureDataBase.documentBasicSalary)
        ref.getDocument { document, error in
            if let document = document, document.exists {
                UserDefaultKeys.basicSalary.setValue(value: document.data()?[ConfigureDataBase.fieldValueSalary] as? [String:Int] ?? ["":0])
            }
        }
    }
    
    func fetchNewsletter() {
        ConfigureDataBase.instance.collection(ConfigureDataBase.collectionNewsletter).getDocuments { querySnapshot, error in
            if error == nil {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let image = UIImage(data: Data(base64Encoded: data["image"] as? String ?? "")!)
                    let news = NewsletterModel.Fetch.Newsletter(siteName: data["siteName"] as? String
                                                     , image: image == nil ? UIImage(named: "imovel") : image
                                                     , date: data["date"] as? String
                                                     , href: data["href"] as? String
                                                     , title: data["title"] as? String
                                                     , inserted_in: (data["inserted_in"] as! Timestamp).dateValue())
                    
                    NewsletterModel.listAllNews.append(news)
                }
                NewsletterModel.listAllNews = NewsletterModel.listAllNews.sorted(by: { $0.date?.convertDateToInt() ?? 0 > $1.date?.convertDateToInt() ?? 0 })
            }
        }
        
    }
    
    func fetchAlert(complete:@escaping(responseHandlerMap)) {
        ConfigureDataBase.instance.collection(ConfigureDataBase.collectionParameters).document(ConfigureDataBase.documentAlert).getDocument { documentSnapshot, error in
            if let document = documentSnapshot, document.exists {
                complete(document.data())
            } else {
                complete(.init())
            }
        }
    }
    
}
