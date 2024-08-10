//
//  QuizPresenter.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

protocol QuizPresentationLogic {
    func presentSomething(response: QuizModel.Fetch.Response)
}

class QuizPresenter: QuizPresentationLogic {
    var viewController: QuizDisplayLogic?
    
    // MARK: - Presentation logic
    func presentSomething(response: QuizModel.Fetch.Response) {
        if response.isError {
            viewController?.showSomething(response.object!)
        } else {
            viewController?.showSomething(response.object!)
        }
    }
}

