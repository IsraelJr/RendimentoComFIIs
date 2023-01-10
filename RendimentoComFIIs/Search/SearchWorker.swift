//
//  SearchWorker.swift
//  RendimentoComFII
//
//  Created by Israel Alves on 26/03/22.
//

import Foundation
import UIKit

typealias responseHandlerSearch = (_ response: SearchModel.Fetch.Response) ->()

class SearchWorker {
    func doSomething(request: SearchModel.Fetch.Request, success:@escaping(responseHandlerSearch), fail:@escaping(responseHandlerSearch)) {
        
//            success(.init(object: nil, isError: false, message: nil))
//        
//            fail(.init(object: nil, isError: false, message: nil))
        
    }
    
}
