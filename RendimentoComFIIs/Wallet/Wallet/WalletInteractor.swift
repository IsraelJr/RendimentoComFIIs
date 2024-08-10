//
//  WalletInteractor.swift
//  RendimentoComFII
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

protocol WalletBusinessLogic {
    func setFii(_ fii: FIIModel.Fetch.FII)
    func accessWalletBD(action: CRUD, _ list: [(String,Int64)]?)
    func setMonthlyEarnings(_ totalEarnings: Double?)
}

protocol WalletDataStore {
    var fii: FIIModel.Fetch.FII! { get set }
}

class WalletInteractor: WalletBusinessLogic, WalletDataStore {
    var fii: FIIModel.Fetch.FII!
    var worker: WalletWorker?
    var presenter: WalletPresentationLogic?
    
    func setFii(_ fii: FIIModel.Fetch.FII) {
        self.fii = fii
    }
 
    func accessWalletBD(action: CRUD, _ list: [(String,Int64)]?) {
        worker = WalletWorker()
        switch action {
        case .create:
            worker?.create(request: list!)
        case .read:
            worker?.read(complete: { response in
                self.presenter?.presentWallet(response)
            })
        case .readFuture:
            break
        case .updtate:
            worker?.update(request: list!)
        case .delete:
            worker?.delete()
        case .deleteFuture:
            break
        }
    }
    
    func setMonthlyEarnings(_ totalEarnings: Double?) {
        guard let total = totalEarnings else { return }
        worker = WalletWorker()
        worker?.saveMonthlyEarnings(total: total, complete: { response in
            print(#function)
        })
    }
    
}
