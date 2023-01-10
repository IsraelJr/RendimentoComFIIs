//
//  SearchPresenter.swift
//  RendimentoComFII
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

protocol SearchPresentationLogic {
    func presentSomething(response: SearchModel.Fetch.Response)
}

class SearchPresenter: SearchPresentationLogic {
    var viewController: SearchDisplayLogic?
    
    // MARK: - Presentation logic
    func presentSomething(response: SearchModel.Fetch.Response) {
        if response.isError {
//            viewController?.showSomething(response.object!)
        } else {
//            viewController?.showSomething(response.object!)
        }
    }
}

