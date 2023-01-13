//
//  PublicPresenter.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

protocol PublicPresentationLogic {
    func presentSomething(response: PublicModel.Fetch.Response)
}

class PublicPresenter: PublicPresentationLogic {
    var viewController: PublicDisplayLogic?
    
    // MARK: - Presentation logic
    func presentSomething(response: PublicModel.Fetch.Response) {
        if response.isError {
            viewController?.showSomething(response.object!)
        } else {
            viewController?.showSomething(response.object!)
        }
    }
}

