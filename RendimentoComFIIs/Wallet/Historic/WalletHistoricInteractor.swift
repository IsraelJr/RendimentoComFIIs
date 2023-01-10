//
//  WalletHistoricInteractor.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

protocol WalletHistoricBusinessLogic {
    func accessWalletHistoric(action: CRUD, _ date: (month: String, year: String))
}

protocol WalletHistoricDataStore {
    var something: String! { get set }
}

class WalletHistoricInteractor: WalletHistoricBusinessLogic, WalletHistoricDataStore {
    var something: String!
    var worker: WalletHistoricWorker?
    var presenter: WalletHistoricPresentationLogic?
    
    func accessWalletHistoric(action: CRUD, _ date: (month: String, year: String)) {
        worker = WalletHistoricWorker()
        switch action {
        case .create:
            worker?.saveMonthlyEarnings(updateDate: date, complete: { response in
                self.presenter?.presentSaveMonth(response: response as! [(Bool,String)])
            })
        case .read:
            break
        case .updtate:
            break
        case .delete:
            break
        }
    }
    
}
