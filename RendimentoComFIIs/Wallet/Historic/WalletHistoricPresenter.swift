//
//  WalletHistoricPresenter.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

protocol WalletHistoricPresentationLogic {
    func presentSaveMonth(response: [(Bool,String)])
}

class WalletHistoricPresenter: WalletHistoricPresentationLogic {
    var viewController: WalletHistoricDisplayLogic?
    
    // MARK: - Presentation logic
    func presentSaveMonth(response: [(Bool,String)]) {
        if response.first?.0 == true {
            let msg = (response.first?.1 ?? "").isEmpty ? NSLocalizedString("success_msg1", comment: "") : response.first?.1 ?? ""
            viewController?.successSaveMonth(msg)
        } else {
            let msg = (response.first?.1 ?? "").isEmpty ? NSLocalizedString("critical_error", comment: "") : response.first?.1 ?? ""
            viewController?.errorSaveMonth(msg)
        }
    }
}

