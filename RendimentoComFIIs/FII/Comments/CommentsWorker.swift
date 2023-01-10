//
//  CommentsWorker.swift
//  RendimentoComFII
//
//  Created by Israel Alves on 26/03/22.
//

import Foundation
import UIKit
import SwiftSoup

typealias responseHandlerComments = (_ response: [Comments]) ->()

class CommentsWorker {
    func doSomething(request: String, success:@escaping(responseHandlerComments), fail:@escaping(responseHandlerComments)) {
        var listComments = [Comments]()
        let site = request.elementsEqual("ARCT11") ? "https://br.investing.com/equities/iridium-recebiveis-imobiliarios-commentary" : "https://www.google.com"
        let url = URL(string: site)
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            if error != nil {
                return
            }
            let html = String(data: data!, encoding: .utf8) ?? ""
            do {
                let doc: Document = try SwiftSoup.parse(html)
                let class1 = try doc.getElementsByClass("comment_comment-wrapper__hJ8sd")
                
                if !class1.isEmpty() {
                    for i in 0...2{
                        listComments.append(.init(author: "Anônimo",
                                                  comments: try class1[i].getElementsByClass("comment_content__AvzPV").first()?.text() ?? "",
                                                  date: try class1[i].getElementsByClass("comment_chat-header__36SjM").first()?.text() ?? "",
                                                  site: "Investing.com"))
                    }
                }
                let url = URL(string: "https://www.guiainvest.com.br/h/\(request)?sigla=\(request)")
                let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
                    if error != nil {
                        return
                    }
                    let html = String(data: data!, encoding: .utf8)!
                    do {
                        let doc: Document = try SwiftSoup.parse(html)
                        let class0 = try doc.select("tr")
                        try class0.forEach({
                            let x = try $0.getElementsByClass("PublicacaoItem")
                            if !x.isEmpty(), listComments.count < 6 {
                                let author = try $0.getElementsByClass("coluna-mural-b").select("a").text()
                                let date = try $0.getElementsByClass("coluna-mural-b").first()?.getElementById("lbDthrInclusao")?.text()
                                let comments = try $0.getElementsByClass("publicacaoConteudo").select("span").text()
                                
                                listComments.append(.init(author: author, comments: comments, date: date, site: "GuiaInvest"))
                            }
                        })
                        if listComments.isEmpty {
                            fail(listComments)
                        } else {
                            success(listComments)
                        }
                        
                    } catch Exception.Error(type: let type, Message: let message) {
                        print("Erro aqui: \(type) / \(message)")
                        listComments.removeAll()
                        fail(listComments)
                    } catch {
                        print("erro")
                        listComments.removeAll()
                        fail(listComments)
                    }
                }
                task.resume()
                
            } catch Exception.Error(type: let type, Message: let message) {
                print("Erro aqui: \(type) / \(message)")
                listComments.removeAll()
                fail(listComments)
            } catch {
                print("erro")
                listComments.removeAll()
                fail(listComments)
            }
        }
        task.resume()
        
        
    }
    
}
