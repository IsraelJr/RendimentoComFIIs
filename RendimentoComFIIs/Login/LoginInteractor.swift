//
//  LoginInteractor.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

protocol LoginBusinessLogic {
    func getTerms()
}

protocol LoginDataStore {
    var something: String! { get set }
}

class LoginInteractor: LoginBusinessLogic, LoginDataStore {
    var something: String!
    var worker: LoginWorker?
    var presenter: LoginPresentationLogic?
    
    init() {
        downloadData()
    }
    
    func getTerms() {
        worker = LoginWorker()
        worker?.fetchTerms(complete: { response in
            self.presenter?.presentTerms(response)
        })
    }
    
    private func downloadData() {
        let worker = InitializationWorker()
        worker.fetch(complete: { response in
            HomeWorker().fetchTallAndShort()
        })
        worker.fetchQuotes { response in
            //
        }
        worker.fetchIFIX { response in
            //
        } fail: { response in
            //
        }
    }
    
}
