//
//  SummaryWorker.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import Foundation
import UIKit

typealias responseHandlerSummary = (_ response: SummaryModel.Fetch.Response) ->()

class SummaryWorker {
    init() {
        ConfigureDataBase.instance.clearPersistence()
    }
    
    func doSomething(request: SummaryModel.Fetch.Request, success:@escaping(responseHandlerSummary), fail:@escaping(responseHandlerSummary)) {
        let doc = ConfigureDataBase.instance.collection(ConfigureDataBase.collectionUser).document(DataUser.email ?? "")
        doc.getDocument { document, error in
            //            success(.init(object: nil, isError: false, message: nil))
            //
            //            fail(.init(object: nil, isError: false, message: nil))
        }
    }
    
}
