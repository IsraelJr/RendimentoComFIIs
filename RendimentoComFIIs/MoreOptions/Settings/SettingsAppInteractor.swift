//
//  SettingsAppInteractor.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

protocol SettingsAppBusinessLogic {
    func saveSettings(/*request: SettingsAppModel.Fetch.Request*/)
}

protocol SettingsAppDataStore {
    var something: String! { get set }
}

class SettingsAppInteractor: SettingsAppBusinessLogic, SettingsAppDataStore {
    var something: String!
    var worker: SettingsAppWorker?
    var presenter: SettingsAppPresentationLogic?
    
    func saveSettings(/*request: SettingsAppModel.Fetch.Request*/) {
        worker = SettingsAppWorker()
        worker?.save(complete: { response in
            self.presenter?.presentMessage(response: response)
        })
    }
    
}
