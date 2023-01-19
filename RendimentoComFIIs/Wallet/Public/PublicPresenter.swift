//
//  PublicPresenter.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

protocol PublicPresentationLogic {
    func presentResult(_ action: CRUD,_ response: Bool)
    func presentWalletPublic(_ responseObject: PublicModel.Fetch.Response?)
}

class PublicPresenter: PublicPresentationLogic {
    var viewController: PublicDisplayLogic?
    
    // MARK: - Presentation logic
    func presentResult(_ action: CRUD,_ response: Bool) {
        viewController?.showResultCRUD(NSLocalizedString("\(action.rawValue)_\(response ? "success" : "error")", comment: ""), response)
    }
    
    func presentWalletPublic(_ responseObject: PublicModel.Fetch.Response?) {
        viewController?.publicWalletDataShow(responseObject?.object)
    }
}

