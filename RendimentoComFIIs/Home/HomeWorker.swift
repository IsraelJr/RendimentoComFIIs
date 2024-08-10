//
//  HomeWorker.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import Foundation
import UIKit
import FirebaseFirestore
import Firebase
import SwiftSoup

typealias responseHandlerHome = (_ response: HomeModel.Fetch.Response) ->()
typealias responseHandlerListFII = (_ response: [FIIModel.Fetch.FII]) ->()
//typealias responsePublicationFiis = (_ response: [FiisNews]) ->()
typealias responseHandlerIPhrase = (_ response: HomeModel.FetchPhrase.Response) ->()

class HomeWorker {
    
    init() {
        ConfigureDataBase.instance.clearPersistence()
    }
    
    //    func fetchTallAndShort(complete:@escaping(responseHandlerArrayOfArrayOfTuple)) {
    func fetchTallAndShort() {
        let url = URL(string: "https://www.infomoney.com.br/cotacoes/b3/indice/ifix/")
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            if error != nil {
                return
            }
            var listHigh = [(String, Double)]()
            var listLow = [(String, Double)]()
            let html = String(data: data!, encoding: .utf8)!
            do {
                let doc: Document = try SwiftSoup.parse(html)
                let table = try doc.getElementsByClass("data-table-full").first()
                let trs = try table?.select("tr")
                
                try trs?.forEach({
                    let code = try $0.select("a").text()
                    if !code.isEmpty {
                        if Double(try $0.select("td")[2].text().convertCurrencyToDouble()) >= 0.0 {
                            listHigh.append((code, try $0.select("td")[2].text().convertCurrencyToDouble()))
                        } else {
                            listLow.append((code, try $0.select("td")[2].text().convertCurrencyToDouble()))
                        }
                    }
                    
                })
                
                listHigh.sort{($0.1) > ($1.1)}
                listLow.sort{($0.1) < ($1.1)}
                for i in 0...1 {
                    while(true) {
                        for y in 0..<( i == 0 ? listHigh.count : listLow.count ) {
                            if let fii = ListFii.listFiis.first(where: {$0.code == (i == 0 ? listHigh[y].0 : listLow[y].0) }) {
                                HomeModel.listHighLow.append(fii)
                                break
                            }
                        }
                        break
                    }
                }
            } catch Exception.Error(type: let type, Message: let message) {
                print("Erro aqui: \(type) / \(message)")
                //                complete([.init(), .init()])
            } catch {
                print("Erro generico")
                //                complete([.init(), .init()])
            }
        }
        task.resume()
    }
    
    func fetchPublications(request: [Sites], result:@escaping(responseFiisComBrNoticias)) {
        PublicationSites().fetchPublications(sites: request) { list in
            result(list)
        }
    }
    
    func hideAlertMessage(done:@escaping(responseDone)) {
        UserDefaults.standard.set(true, forKey: UserDefaultKeys.hideNewsAlert.rawValue)
        done(true)
    }
    
    func fetchPhrase(success:@escaping(responseHandlerIPhrase), fail:@escaping(responseHandlerIPhrase)) {
        ConfigureDataBase.instance.collection(ConfigureDataBase.collectionPhrases).getDocuments { querySnapshot, error in
            if error == nil {
                var listPhrases = [HomeModel.FetchPhrase.Phrase]()
                for document in querySnapshot!.documents {
                    let obj = document.data()
                    listPhrases.append(.init(author: obj["author"] as? String , phrase: obj["phrase"] as? String))
                }
                if !listPhrases.isEmpty {
                    success(.init(object: listPhrases[Int.random(in: 0..<listPhrases.count)], isError: false, message: nil))
                } else {
                    fail(.init())
                }
            }else {
                fail(.init())
            }
        }
        
    }
    
    func fetchImageItemsLibrary(complete:@escaping(responseDone)) {
        if HomeModel.listItensLibrary.isEmpty {
            ConfigureDataBase.instance.collection(ConfigureDataBase.collectionLibrary).getDocuments { querySnapshot, error in
                if error == nil {
                    for document in querySnapshot!.documents {
                        let obj = document.data()
                        HomeModel.listItensLibrary.append((obj["image"] as! String, obj[Util.locale] as! String))
                    }
                    HomeModel.listItensLibrary.sort(by: {$0.1 < $1.1})
                    complete(true)
                }else {
                    complete(false)
                }
            }
        } else {
            complete(true)
        }
    }
    
}
