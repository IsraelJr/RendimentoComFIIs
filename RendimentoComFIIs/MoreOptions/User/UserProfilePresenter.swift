//
//  UserProfilePresenter.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

protocol UserProfilePresentationLogic {
    func presentDeleteWallet(_ response: Bool)
    func presentDeleteAccount(_ response: Bool)
}

class UserProfilePresenter: UserProfilePresentationLogic {
    var viewController: UserProfileDisplayLogic?
    
    // MARK: - Presentation logic
    func presentDeleteWallet(_ response: Bool) {
        viewController?.deletedWallet(response)
    }
    
    func presentDeleteAccount(_ response: Bool) {
        viewController?.deletedAccount(response)
    }
}

