//
//  AboutAppInteractor.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

protocol AboutAppBusinessLogic {
    func getAboutApp()
}

protocol AboutAppDataStore {
    var something: String! { get set }
}

class AboutAppInteractor: AboutAppBusinessLogic, AboutAppDataStore {
    var something: String!
    var worker: AboutAppWorker?
    var presenter: AboutAppPresentationLogic?
    
    func getAboutApp() {
        if AboutAppModel.Fetch.AboutApp.description.isEmpty {
            worker = AboutAppWorker()
            worker?.fetch(complete: { response in
                self.presenter?.presentAboutApp(AboutAppModel.Fetch.AboutApp.description)
            })
        } else {
            self.presenter?.presentAboutApp(AboutAppModel.Fetch.AboutApp.description)
        }
    }
    
}
