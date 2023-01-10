//
//  AboutAppPresenter.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

protocol AboutAppPresentationLogic {
    func presentAboutApp(_ response: String)
}

class AboutAppPresenter: AboutAppPresentationLogic {
    var viewController: AboutAppDisplayLogic?
    
    // MARK: - Presentation logic
    func presentAboutApp(_ response: String) {
        viewController?.setAbout(response)
    }
}

