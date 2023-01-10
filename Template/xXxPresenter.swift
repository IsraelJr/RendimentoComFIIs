//
//  xXxPresenter.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

protocol xXxPresentationLogic {
    func presentSomething(response: xXxModel.Fetch.Response)
}

class xXxPresenter: xXxPresentationLogic {
    var viewController: xXxDisplayLogic?
    
    // MARK: - Presentation logic
    func presentSomething(response: xXxModel.Fetch.Response) {
        if response.isError {
            viewController?.showSomething(response.object!)
        } else {
            viewController?.showSomething(response.object!)
        }
    }
}

