//
//  InitializationPresenter.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

protocol InitializationPresentationLogic {
    func presentNewOrUpdatedItem(_ response: [(ItemsLibrary, Bool)])
    func presentHomeViewController()
    func presentAlertMessage(_ message: String)
}

class InitializationPresenter: InitializationPresentationLogic {
    var viewController: InitializationDisplayLogic?
    
    // MARK: - Presentation logic
    func presentNewOrUpdatedItem(_ response: [(ItemsLibrary, Bool)]) {
        viewController?.flagNewOrUpdatedItem(response)
    }
    
    func presentHomeViewController() {
        viewController?.callHomeViewController()
    }

    func presentAlertMessage(_ message: String) {
        viewController?.showAlertMessage(message)
    }
}

