//
//  SummaryPresenter.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

protocol SummaryPresentationLogic {
    func presentSomething(response: SummaryModel.Fetch.Response)
}

class SummaryPresenter: SummaryPresentationLogic {
    var viewController: SummaryDisplayLogic?
    
    // MARK: - Presentation logic
    func presentSomething(response: SummaryModel.Fetch.Response) {
        if response.isError {
            viewController?.showSomething(response.object!)
        } else {
            viewController?.showSomething(response.object!)
        }
    }
}

