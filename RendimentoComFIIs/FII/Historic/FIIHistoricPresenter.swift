//
//  FIIHistoricPresenter.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

protocol FIIHistoricPresentationLogic {
    func presentHistoric(_ response: FIIHistoricModel.Fetch.Response, _ code: String)
}

class FIIHistoricPresenter: FIIHistoricPresentationLogic {
    var viewController: FIIHistoricDisplayLogic?
    
    // MARK: - Presentation logic
    func presentHistoric(_ response: FIIHistoricModel.Fetch.Response, _ code: String) {
//        if response.isError {
            viewController?.showHistoric(response.object, code)
//        } else {
//            viewController?.showSomething(response.object!)
//        }
    }
}

