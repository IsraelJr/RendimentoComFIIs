//
//  FIIPresenter.swift
//  RendimentoComFII
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

protocol FIIPresentationLogic {
    func presentFII(_ response: FIIModel.Fetch.Response)
    func presentLastReport(_ response: [Any])
}

class FIIPresenter: FIIPresentationLogic {
    var viewController: FIIDisplayLogic?
    
    // MARK: - Presentation logic
    func presentFII(_ response: FIIModel.Fetch.Response) {
        if response.isError {
            viewController?.displayError(response.message ?? "")
        } else {
            viewController?.displaySuccess(response.object!)
        }
    }
    
    func presentLastReport(_ response: [Any]) {
        viewController?.setLastReport(response.first as! String)
    }
}

