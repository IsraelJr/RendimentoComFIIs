//
//  LoginPresenter.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

protocol LoginPresentationLogic {
    func presentTerms(_ response: LoginModel.FetchTerms.Response)
}

class LoginPresenter: LoginPresentationLogic {
    var viewController: LoginDisplayLogic?
    
    // MARK: - Presentation logic
    func presentTerms(_ response: LoginModel.FetchTerms.Response) {
           viewController?.setTerms(response.object!)
    }
}

