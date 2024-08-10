//
//  PublicationSites.swift
//  RendimentoComFII
//
//  Created by Israel Alves on 31/03/22.
//

import Foundation
import SwiftSoup

typealias responseFiisComBrNoticias = (_ response: [FiisNews]) ->()

enum Sites: String, CaseIterable {
    case fiis
    case suno
    case valorinveste
    case euqueroinvestir
    case all
}

struct FiisNews {
    var siteName: String!
    var image: UIImage?
    var date: String?
    var href: String?
    var title: String?
}

class PublicationSites {
    var listNews = [FiisNews]()
    let maxNews = 3
    var numberEuqueroinv = 0
    let listArchivedNews = ["https://valorinveste.globo.com/produtos/fundos-imobiliarios/",
                            "https://comoinvestir.thecap.com.br/t/fundos-imobiliarios",
                            "https://www.moneytimes.com.br/tag/fundos-imobiliarios/",
                            "https://bmcnews.com.br/programas/bmc-radar-fiis/",
                            "https://imoveis.estadao.com.br/investir-imoveis/",
                            "http://br.advfn.com/jornal/outros-investimentos/fundos-imobiliarios"
    ]
    
    func fetchPublications(sites: [Sites], completion:@escaping(responseFiisComBrNoticias)) {
        var count = 0
        sites.forEach({
            switch $0 {
            case .fiis:
                fiisNewsSites(completion: { _ in completion(self.listNews) })
            case .suno:
                sunoNewsSites(completion: { _ in completion(self.listNews) })
            case .euqueroinvestir:
                euqueroinvNewsSites(completion: { _ in completion(self.listNews) })
            case .valorinveste:
                valorinvesteNewsSites(completion: { _ in completion(self.listNews) })
            case .all:
                fiisNewsSites(completion: { _ in
                    self.sunoNewsSites(completion: { _ in
                        count += 1
                        if count <= 1 {
                            self.euqueroinvNewsSites { _ in
                                self.valorinvesteNewsSites { _ in
                                    completion(self.listNews)
                                }
                            }
                        }
                    })
                    
                })
            }
        })
    }
    
    private func fiisNewsSites(completion:@escaping(responseDone)) {
        let task = URLSession.shared.dataTask(with: URL(string: "https://fiis.com.br/noticias/")!) {(data, response, error) in
            if error != nil {
                completion(false)
                return
            }
            let html = String(data: data!, encoding: .utf8)!
            do {
                let doc: Document = try SwiftSoup.parse(html)
                
                let featured = try doc.getElementsByClass("featured-publication").first()
                
                if featured != nil {
                    let titleFeatured = try featured?.getElementsByClass("text-wrapper").first()
                    
                    let styleFeatured = try featured?.getElementsByClass("img-wrapper").first()?.attr("style").replacingOccurrences(of: "background-image: url(\'", with: "").replacingOccurrences(of: "')", with: "") ?? "https://www.google.com"
                    let urlImageFeatured = URL(string: styleFeatured.isEmpty ? "https://www.google.com" : styleFeatured)
                    self.listNews.append(FiisNews(siteName: Sites.fiis.rawValue.uppercased()
                                                  , image: /*UIImage(data: try! Data(contentsOf: urlImageFeatured!)) ??*/ UIImage(named: "imovel")
                                                  , date: try titleFeatured!.getElementsByClass("date").first()?.text().dateTextWithYYYY()
                                                  , href: try titleFeatured!.select("a").attr("href")
                                                  , title: try titleFeatured!.getElementsByClass("title").first()?.text()
                                                 ))
                    
                    
                    
                    let list = try doc.getElementsByClass("main-publications").first()?.getElementsByClass("pub-wrapper")
                    try list?.forEach({
                        let style = try $0.getElementsByClass("img-wrapper").first()?.attr("style").replacingOccurrences(of: "background-image: url(\'", with: "").replacingOccurrences(of: "')", with: "")
                        let urlImage = URL(string: style!.isEmpty ? "https://www.google.com" : style!)
                        self.listNews.append(FiisNews(siteName: Sites.fiis.rawValue.uppercased()
                                                      , image: urlImage == nil ? UIImage(named: "imovel") : UIImage(data: try! Data(contentsOf: urlImage!))
                                                      , date: try $0.getElementsByClass("date").first()?.text().dateTextWithYYYY()
                                                      , href: try $0.select("a").attr("href")
                                                      , title: try $0.getElementsByClass("title").first()?.text()
                                                     ))
                    })
                }
                completion(true)
            } catch Exception.Error(type: let type, Message: let message) {
                print("Erro aqui: \(type) / \(message)")
                completion(false)
            } catch {
                print("erro")
                completion(false)
            }
        }
        task.resume()
    }
    
    private func sunoNewsSites(completion:@escaping(responseDone)) {
        let task = URLSession.shared.dataTask(with: URL(string: "https://www.suno.com.br/noticias/imoveis/")!) {(data, response, error) in
            if error != nil {
                completion(false)
                return
            }
            let html = String(data: data!, encoding: .utf8)!
            do {
                let doc: Document = try SwiftSoup.parse(html)
                let listA = try doc.getElementsByClass("categoryHeader").first()?.getElementsByClass("categoryHeader__highlight")
                let src = try listA?.first()!.getElementsByClass("categoryHeader__highlight__link__img").first()?.attr("src")
                
                try listA?.forEach({ item in
                    let urlImage = URL(string: src!.isEmpty ? "https://www.google.com" : src!)
                    let href = try item.select("a").attr("href")
                    
                    let task = URLSession.shared.dataTask(with: URL(string: href)!) {(data, response, error) in
                        if error != nil {
                            return
                        }
                        let html = String(data: data!, encoding: .utf8)!
                        do {
                            let doc: Document = try SwiftSoup.parse(html)
                            self.listNews.append(FiisNews(siteName: Sites.suno.rawValue.uppercased()
                                                          , image: /*UIImage(data: try! Data(contentsOf: urlImage!)) ?? */UIImage(named: "imovel")
                                                          , date: try doc.getElementsByClass("authorBox__name").select("time").text().dateTextWithYYYY()
                                                          , href: href
                                                          , title: try item.getElementsByClass("categoryHeader__highlight__link__title").first()?.text()
                                                         ))
                        } catch Exception.Error(type: let type, Message: let message) {
                            print("Erro aqui: \(type) / \(message)")
                            completion(false)
                        } catch {
                            print("erro")
                            completion(false)
                        }
                    }
                    
                    task.resume()
                    
                })
                
                let listB = try doc.getElementsByClass("categoryHeader").first()?.getElementsByClass("categoryHeader__4box").select("a")
                try listB?.forEach({ itemB in
                    let src = try itemB.getElementsByClass("categoryHeader__4box__box__img").first()?.attr("src")
                    let urlImage = URL(string: src!.isEmpty ? "https://www.google.com" : src!)
                    let href = try itemB.attr("href")
                    
                    let task = URLSession.shared.dataTask(with: URL(string: href)!) {(data, response, error) in
                        if error != nil {
                            completion(false)
                            return
                        }
                        let html = String(data: data!, encoding: .utf8)!
                        do {
                            let doc: Document = try SwiftSoup.parse(html)
                            self.listNews.append(FiisNews(siteName: Sites.suno.rawValue.uppercased()
                                                          , image: /*UIImage(data: try! Data(contentsOf: urlImage!)) ?? */UIImage(named: "imovel")
                                                          , date: try doc.getElementsByClass("authorBox__name").select("time").text().dateTextWithYYYY()
                                                          , href: href
                                                          , title: try itemB.getElementsByClass("categoryHeader__4box__box__title").first()?.text()
                                                         ))
                            completion(true)
                        } catch Exception.Error(type: let type, Message: let message) {
                            print("Erro aqui: \(type) / \(message)")
                            completion(false)
                        } catch {
                            print("erro")
                            completion(false)
                        }
                    }
                    
                    task.resume()
                })
                
            } catch Exception.Error(type: let type, Message: let message) {
                print("Erro aqui: \(type) / \(message)")
                completion(false)
            } catch {
                print("erro")
                completion(false)
            }
        }
        task.resume()
    }
    
    private func euqueroinvNewsSites(completion:@escaping(responseDone)) {
        let url = URL(string: "https://www.euqueroinvestir.com/fundos-imobiliarios")  //"https://www.euqueroinvestir.com/assunto/fundos-imobiliarios/")
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            if error != nil {
                completion(false)
                return
            }
            let html = String(data: data!, encoding: .utf8)!
            do {
                let doc: Document = try SwiftSoup.parse(html)
                var rows = try doc.getElementsByClass("category-featured")
                if rows.isEmpty() {
                    completion(false)
                    return
                }
                rows = try doc.getElementsByClass("category-featured")[0].getElementsByClass("article-teaser")
                try rows.forEach({
                    let src = try $0.getElementsByClass("article-teaser-photo").select("img").attr("src")
                    let urlImage = URL(string: src.isEmpty ? "https://www.google.com" : src)
                    let href = try $0.getElementsByClass("article-teaser-title").select("a").attr("href")
                    self.listNews.append(FiisNews(siteName: Sites.euqueroinvestir.rawValue.uppercased()
                                                  , image: /*UIImage(data: try! Data(contentsOf: urlImage!)) ??*/ UIImage(named: "imovel")
                                                  , date: try $0.getElementsByClass("article-teaser-author").select("span")[2].attr("content").dateTextWithYYYY()
                                                  , href: href
                                                  , title: try $0.getElementsByClass("article-teaser-title").select("a").text()
                                                 ))
                    
                })
                completion(true)
            } catch Exception.Error(type: let type, Message: let message) {
                print("Erro aqui: \(type) / \(message)")
                completion(false)
            } catch {
                print("erro")
                completion(false)
            }
        }
        task.resume()
    }
    
    private func valorinvesteNewsSites(completion:@escaping(responseDone)) {
        var url = URL(string: "https://valorinveste.globo.com/produtos/fundos-imobiliarios/")
        let taskUm = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            if error != nil {
                completion(false)
                return
            }
            let html = String(data: data!, encoding: .utf8)!
            do {
                let doc: Document = try SwiftSoup.parse(html)
                let items = try doc.getElementsByClass("bastian-page").first()?.getElementsByClass("feed-post bstn-item-shape type-materia")
                var list = [(link: String, img: String)]()
                try items?.forEach({
                    let link = try $0.select("a").attr("href")
                    let img = try $0.getElementsByClass("bstn-fd-picture-image").first()?.attr("src")
                    list.append((link: link , img: img ?? ""))
                })
                let count = list.count >= 5 ? 5 : list.count
                for i in 0..<count {
                    url = URL(string: list[i].link)
                    let taskDois = URLSession.shared.dataTask(with: url!) {(data, response, error) in
                        if error != nil {
                            completion(false)
                            return
                        }
                        let html = String(data: data!, encoding: .utf8)!
                        do {
                            let doc: Document = try SwiftSoup.parse(html)
                            let urlImage = URL(string: list[i].img)
                            let title = try doc.getElementsByClass("content-head__title").first()?.text()
                            self.listNews.append(FiisNews(siteName: Sites.valorinveste.rawValue.uppercased()
                                                          , image: urlImage == nil ? UIImage(named: "imovel") : UIImage(data: try! Data(contentsOf: urlImage!))
                                                          , date: try doc.getElementsByClass("content-publication-data__updated").first()?.text()  //.dateTextWithYYYY()
                                                          , href: list[i].link
                                                          , title: title
                                                         ))
                            if i >= count-1 {
                                completion(true)
                            }
                        } catch Exception.Error(type: let type, Message: let message) {
                            print("Erro aqui: \(type) / \(message)")
                            completion(false)
                        } catch {
                            print("erro")
                            completion(false)
                        }
                    }
                    taskDois.resume()
                }
            } catch Exception.Error(type: let type, Message: let message) {
                print("Erro aqui: \(type) / \(message)")
                completion(false)
            } catch {
                print("erro")
                completion(false)
            }
        }
        taskUm.resume()
    }
}
