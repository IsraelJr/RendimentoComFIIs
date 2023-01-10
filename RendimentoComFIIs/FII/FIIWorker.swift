//
//  FIIWorker.swift
//  RendimentoComFII
//
//  Created by Israel Alves on 26/03/22.
//

import Foundation
import UIKit
import FirebaseFirestore
import SwiftSoup

typealias responseHandlerFII = (_ response: FIIModel.Fetch.Response) ->()

class FIIWorker {
    
    init() {
        ConfigureDataBase.instance.clearPersistence()
    }
    
    func fetch(request: FIIModel.Fetch.Request, success:@escaping(responseHandlerFII), fail:@escaping(responseHandlerFII)) {
        if ListFii.listFiis.isEmpty {
            ListFii.getListLocal()
        }
        if var obj = ListFii.listFiis.first(where: {$0.code == request.object?.code}) {
            obj.price = quoteList.first(where: {$0.code == obj.code})?.currentPrice
            obj.calcEquityValuePerShare()
            obj.calcPVP()
            success(.init(object: obj, isError: false, message: nil))
        } else {
            fail(.init(object: nil, isError: true, message: "Not Found"))
        }
        
    }
    
    func fetchLastReport(code: String, result:@escaping(responseHandlerArray)) {
        ListFii.getReport(code) { response in
            let url = (response.first as! String).isEmpty ? ListFii.listFiis.first(where: { $0.code.elementsEqual(code) })?.hrefReport ?? "" : response.first as! String
            if url.isEmpty {
                self.extractLastReport(code) { response in
                    (response.first as! String).isEmpty ? result([""]) : result([response.first as! String])
                }
            } else {
                result([url])
            }
        }
        
        
    }
    
    private func extractLastReport(_ code: String, result:@escaping(responseHandlerArray)) {
        let url = URL(string: "https://www.ivalor.com.br/fiis/\(code)")!
        let taskUm = URLSession.shared.dataTask(with: url) {(data, response, error) in
            if error != nil {
                result([""])
                return
            }
            let html = String(data: data!, encoding: .utf8)!
            do {
                let doc: Document = try SwiftSoup.parse(html)
                result([try doc.getElementsByClass("col-sm-12 mr-auto ml-auto text-center").select("a").attr("href")])
                
            } catch Exception.Error(type: let type, Message: let message) {
                print("Erro aqui: \(type) / \(message)")
                result([""])
            } catch {
                print("erro")
                result([""])
            }
        }
        taskUm.resume()
    }
    
}
