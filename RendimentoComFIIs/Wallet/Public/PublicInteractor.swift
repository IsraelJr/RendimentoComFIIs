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
                UserDefaultKeys.wallet_public_has.setValue(value: response)
                UserDefaultKeys.wallet_public_isVisible.setValue(value: response)
                self.presenter?.presentResult(action, response)
            })
        case .read:
            if UserDefaultKeys.wallet_public_has.getValue() as! Bool {
                worker?.read(complete: { response in
                    response ? self.presenter?.presentWalletPublic(self.worker?.getWalletPublic()) : self.presenter?.presentResult(action, response)
                })
            }
        case .readFuture:
            break
            
        case .updtate:
            worker?.update(complete: { response in
                self.presenter?.presentResult(action, response)
            })
        case .delete:
            worker?.delete(complete: { response in
                self.presenter?.presentResult(action, response)
            })
        case .deleteFuture:
            break
        }
    }
    
}
