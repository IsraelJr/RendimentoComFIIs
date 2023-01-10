//
//  FIIInteractor.swift
//  RendimentoComFII
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

protocol FIIBusinessLogic {
    func getFii()
}

protocol FIIDataStore {
    var fii: FIIModel.Fetch.FII! { get set }
}

class FIIInteractor: FIIBusinessLogic, FIIDataStore {
    var fii: FIIModel.Fetch.FII!
    var worker: FIIWorker?
    var presenter: FIIPresentationLogic?
    
    func getFii() {
        worker = FIIWorker()
        getLastReport(self.fii.code)
        worker?.fetch(request: FIIModel.Fetch.Request.init(object: self.fii), success: { response in
            self.presenter?.presentFII(response)
        }, fail: { response in
            self.presenter?.presentFII(response)
        })
    }
    
    private func getLastReport(_ code: String) {
        worker = FIIWorker()
        worker?.fetchLastReport(code: code, result: { response in
            self.presenter?.presentLastReport(response)
        })
    }
    
}
