//
//  MoreOptionsPresenter.swift
//  RendimentoComFII
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

protocol MoreOptionsPresentationLogic {
    func presentSomething(response: MoreOptionsModel.Fetch.Response)
}

class MoreOptionsPresenter: MoreOptionsPresentationLogic {
    var viewController: MoreOptionsDisplayLogic?
    
    // MARK: - Presentation logic
    func presentSomething(response: MoreOptionsModel.Fetch.Response) {
        if response.isError {
            viewController?.showSomething(response.object!)
        } else {
            viewController?.showSomething(response.object!)
        }
    }
}

