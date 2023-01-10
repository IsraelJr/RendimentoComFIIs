//
//  xXxInteractor.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

protocol xXxBusinessLogic {
    func doSomething(request: xXxModel.Fetch.Request)
}

protocol xXxDataStore {
    var something: String! { get set }
}

class xXxInteractor: xXxBusinessLogic, xXxDataStore {
    var something: String!
    var worker: xXxWorker?
    var presenter: xXxPresentationLogic?
    
    func doSomething(request: xXxModel.Fetch.Request) {
        worker = xXxWorker()
        worker?.doSomething(request: request, success: { response in
            self.presenter?.presentSomething(response: response)
        }, fail: { response in
            self.presenter?.presentSomething(response: response)
        })
    }
    
}
