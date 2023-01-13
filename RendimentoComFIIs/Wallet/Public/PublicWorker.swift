//
//  PublicWorker.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import Foundation
import UIKit

typealias responseHandlerPublic = (_ response: PublicModel.Fetch.Response) ->()

class PublicWorker {
    init() {
        ConfigureDataBase.instance.clearPersistence()
    }
    
    func doSomething(request: PublicModel.Fetch.Request, success:@escaping(responseHandlerPublic), fail:@escaping(responseHandlerPublic)) {
        let doc = ConfigureDataBase.instance.collection(ConfigureDataBase.collectionUser).document(DataUser.email ?? "")
        doc.getDocument { document, error in
            //            success(.init(object: nil, isError: false, message: nil))
            //
            //            fail(.init(object: nil, isError: false, message: nil))
        }
    }
    
}
