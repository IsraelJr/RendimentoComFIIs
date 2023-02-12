//
//  ListWalletPublicInteractor.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

protocol ListWalletPublicBusinessLogic {
    func readWalletPublic()
}

protocol ListWalletPublicDataStore {
    var something: String! { get set }
}

class ListWalletPublicInteractor: ListWalletPublicBusinessLogic, ListWalletPublicDataStore {
    var something: String!
    var worker: ListWalletPublicWorker?
    var presenter: ListWalletPublicPresentationLogic?
    
    func readWalletPublic() {
        worker = ListWalletPublicWorker()
        worker?.read(complete: { response in
            self.presenter?.presentWalletPublic(response)
        })
    }

}
