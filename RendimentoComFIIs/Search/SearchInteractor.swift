//
//  SearchInteractor.swift
//  RendimentoComFII
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

protocol SearchBusinessLogic {
    func setFii(_ fii: FIIModel.Fetch.FII)
}

protocol SearchDataStore {
    var fii: FIIModel.Fetch.FII! { get set }
}

class SearchInteractor: SearchBusinessLogic, SearchDataStore {
    var fii: FIIModel.Fetch.FII!
    var worker: SearchWorker?
    var presenter: SearchPresentationLogic?
    
    func setFii(_ fii: FIIModel.Fetch.FII) {
        self.fii = fii
    }
    
}
