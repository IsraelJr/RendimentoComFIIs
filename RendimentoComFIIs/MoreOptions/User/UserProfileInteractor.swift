//
//  UserProfileInteractor.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

protocol UserProfileBusinessLogic {
    func deleteWallet()
    func deleteAccount()
    func updateAccount()
}

protocol UserProfileDataStore {
    var something: String! { get set }
}

class UserProfileInteractor: UserProfileBusinessLogic, UserProfileDataStore {
    var something: String!
    var worker: UserProfileWorker?
    var presenter: UserProfilePresentationLogic?
    
    func deleteWallet() {
        worker = UserProfileWorker()
        worker?.delete(from: .wallet, complete: { response in
            self.presenter?.presentDeleteWallet(response)
        })
    }
    
    func updateAccount() {
        worker = UserProfileWorker()
        worker?.update()
    }
    
    func deleteAccount() {
        worker = UserProfileWorker()
        worker?.delete(from: .account, complete: { response in
            self.presenter?.presentDeleteAccount(response)
        })
    }
}
