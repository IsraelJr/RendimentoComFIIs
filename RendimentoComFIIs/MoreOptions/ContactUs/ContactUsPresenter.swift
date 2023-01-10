//
//  ContactUsPresenter.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

protocol ContactUsPresentationLogic {
    func presentSuccess(_ response: String)
    func presentError(_ response: String)
}

class ContactUsPresenter: ContactUsPresentationLogic {
    var viewController: ContactUsDisplayLogic?
    
    // MARK: - Presentation logic
    func presentSuccess(_ response: String) {
        viewController?.showSuccess(response)
    }
    
    func presentError(_ response: String) {
            viewController?.showError(response)
    }
}

