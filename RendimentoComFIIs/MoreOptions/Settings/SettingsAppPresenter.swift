//
//  SettingsAppPresenter.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

protocol SettingsAppPresentationLogic {
    func presentMessage(response: SettingsAppModel.Fetch.Response)
}

class SettingsAppPresenter: SettingsAppPresentationLogic {
    var viewController: SettingsAppDisplayLogic?
    
    // MARK: - Presentation logic
    func presentMessage(response: SettingsAppModel.Fetch.Response) {
        if response.isError ?? false {
            viewController?.showMessage(response.message!, false)
        } else {
            viewController?.showMessage(response.message!, true)
        }
    }
}

