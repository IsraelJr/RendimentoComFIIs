//
//  xXxWorker.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import Foundation
import UIKit

typealias responseHandlerxXx = (_ response: xXxModel.Fetch.Response) ->()

class xXxWorker {
    init() {
        ConfigureDataBase.instance.clearPersistence()
    }
    
    func doSomething(request: xXxModel.Fetch.Request, success:@escaping(responseHandlerxXx), fail:@escaping(responseHandlerxXx)) {
        let doc = ConfigureDataBase.instance.collection(ConfigureDataBase.collectionUser).document(DataUser.email ?? "")
        doc.getDocument { document, error in
            //            success(.init(object: nil, isError: false, message: nil))
            //
            //            fail(.init(object: nil, isError: false, message: nil))
        }
    }
    
}
