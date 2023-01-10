//
//  WalletPresenter.swift
//  RendimentoComFII
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

protocol WalletPresentationLogic {
    func presentWallet(_ response: WalletModel.Fetch.Response)
}

class WalletPresenter: WalletPresentationLogic {
    var viewController: WalletDisplayLogic?
    
    // MARK: - Presentation logic
    func presentWallet(_ response: WalletModel.Fetch.Response) {
        if response.isError {
            viewController?.errorWallet(response.message!)
        } else {
            viewController?.successWallet(response.object!)
        }
    }
}

