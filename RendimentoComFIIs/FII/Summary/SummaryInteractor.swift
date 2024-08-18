//
//  SummaryInteractor.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

protocol SummaryBusinessLogic {
    func doSomething(request: SummaryModel.Fetch.Request)
}

protocol SummaryDataStore {
    var something: String! { get set }
}

class SummaryInteractor: SummaryBusinessLogic, SummaryDataStore {
    var something: String!
    var worker: SummaryWorker?
    var presenter: SummaryPresentationLogic?
    
    func doSomething(request: SummaryModel.Fetch.Request) {
        worker = SummaryWorker()
        worker?.doSomething(request: request, success: { response in
            self.presenter?.presentSomething(response: response)
        }, fail: { response in
            self.presenter?.presentSomething(response: response)
        })
    }
    
}
