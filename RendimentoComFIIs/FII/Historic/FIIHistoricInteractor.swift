//
//  FIIHistoricInteractor.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

protocol FIIHistoricBusinessLogic {
    func getHistory()
}

protocol FIIHistoricDataStore {
    var code: String! { get set }
}

class FIIHistoricInteractor: FIIHistoricBusinessLogic, FIIHistoricDataStore {
    var code: String!
    var worker: FIIHistoricWorker?
    var presenter: FIIHistoricPresentationLogic?
    
    func getHistory() {
        worker = FIIHistoricWorker()
        worker?.fetchEarnings(code: code, complete: { response in
            self.presenter?.presentHistoric(response, self.code)
        })
    }
}
