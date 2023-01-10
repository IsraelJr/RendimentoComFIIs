//
//  CommentsPresenter.swift
//  RendimentoComFII
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

protocol CommentsPresentationLogic {
    func setCodeFii(_ code: String)
    func presentSomething(response: [Comments])
}

class CommentsPresenter: CommentsPresentationLogic {
    var viewController: CommentsDisplayLogic?
    
    // MARK: - Presentation logic
    func setCodeFii(_ code: String) {
        viewController?.getCodeFii(code)
    }
    
    func presentSomething(response: [Comments]) {
        //        if response.isEmpty {
        viewController?.showSomething(response)
        //        } else {
        //            viewController?.showSomething(response.object!)
        //    }
    }
}

