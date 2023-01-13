//
//  PublicInteractor.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

protocol PublicBusinessLogic {
    func doSomething(request: PublicModel.Fetch.Request)
}

protocol PublicDataStore {
    var something: String! { get set }
}

class PublicInteractor: PublicBusinessLogic, PublicDataStore {
    var something: String!
    var worker: PublicWorker?
    var presenter: PublicPresentationLogic?
    
    func doSomething(request: PublicModel.Fetch.Request) {
        worker = PublicWorker()
        worker?.doSomething(request: request, success: { response in
            self.presenter?.presentSomething(response: response)
        }, fail: { response in
            self.presenter?.presentSomething(response: response)
        })
    }
    
}
