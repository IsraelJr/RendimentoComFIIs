//
//  PublicInteractor.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

protocol PublicBusinessLogic {
    func accessDataBase(action: CRUD, _ request: PublicModel.Fetch.Request?)
}

protocol PublicDataStore {
    var something: String! { get set }
}

class PublicInteractor: PublicBusinessLogic, PublicDataStore {
    var something: String!
    var worker: PublicWorker?
    var presenter: PublicPresentationLogic?
    
    func accessDataBase(action: CRUD, _ request: PublicModel.Fetch.Request?) {
        worker = PublicWorker()
        switch action {
        case .create:
            worker?.create(request: request!, complete: { response in
                self.presenter?.presentResult(action, response)
            })
        case .read:
            worker?.read(complete: { response in
                self.presenter?.presentResult(action, response)
            })
        case .updtate:
            worker?.update(complete: { response in
                self.presenter?.presentResult(action, response)
            })
        case .delete:
            worker?.delete(complete: { response in
                self.presenter?.presentResult(action, response)
            })
        }
    }
    
}
