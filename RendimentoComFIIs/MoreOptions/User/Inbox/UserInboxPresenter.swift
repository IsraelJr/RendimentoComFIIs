//
//  UserInboxPresenter.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

protocol UserInboxPresentationLogic {
    func presentResultDelete(response: Bool)
    func presentMessages(response: [UserInboxModel.Fetch.Message])
}

class UserInboxPresenter: UserInboxPresentationLogic {
    var viewController: UserInboxDisplayLogic?
    
    // MARK: - Presentation logic
    func presentResultDelete(response: Bool) {
        viewController?.deleteMessage(response)
    }
    
    func presentMessages(response: [UserInboxModel.Fetch.Message]) {
        viewController?.showMessages(response)
    }
}

