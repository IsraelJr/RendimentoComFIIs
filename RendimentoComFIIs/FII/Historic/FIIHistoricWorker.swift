//
//  FIIHistoricWorker.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import Foundation
import UIKit

typealias responseHandlerFIIHistoric = (_ response: FIIHistoricModel.Fetch.Response) ->()

class FIIHistoricWorker {
    
    init() {
        ConfigureDataBase.instance.clearPersistence()
    }
    
    func fetchEarnings(code: String, complete:@escaping(responseHandlerFIIHistoric)) {
        let ref = ConfigureDataBase.instance.collection(ConfigureDataBase.collectionFiis).document(code)
        ref.getDocument { document, error in
            if error == nil {
                if let document = document, document.exists {
                    var list = [[String:Any]]()
                    for year in 2020...Calendar.current.component(.year, from: Date()) {
                        if let data = document.data()?["earnings\(year)"] as? [String:Any] {
                            list.append(["\(year)":data] as [String:Any])
                        }
                    }
                    list.sort(by: {Int($0.first?.key ?? "0")! > Int($1.first?.key ?? "0")!})
                    complete(FIIHistoricModel.Fetch.Response(object: list.isEmpty ? nil : FIIHistoricModel.Fetch.FIIHistoric(earnings: list),
                                                             isError: false,
                                                             message: nil))
                } else {
                    complete(.init(object: nil, isError: true, message: "Não existe"))
                }
            } else {
                complete(.init(object: nil, isError: true, message: "Erro na pesquisa"))
            }
        }
    }
}
