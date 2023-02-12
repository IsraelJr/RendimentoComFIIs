//
//  ListWalletPublicPresenter.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

protocol ListWalletPublicPresentationLogic {
    func presentWalletPublic(_ response: [ListWalletPublicModel.Fetch.ListWalletPublic])
}

class ListWalletPublicPresenter: ListWalletPublicPresentationLogic {
    var viewController: ListWalletPublicDisplayLogic?
    
    // MARK: - Presentation logic
    func presentWalletPublic(_ response: [ListWalletPublicModel.Fetch.ListWalletPublic]) {
        viewController?.showWalletPublic(response)
    }
}

