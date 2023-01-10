//
//  HomePresenter.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

protocol HomePresentationLogic {
    func presentPublications(_ response: [FiisNews])
//    func presenterTallAndShort(_ list: [[(String,String)]])
    func presentPhrase(_ response: HomeModel.FetchPhrase.Response)
    func presentItemsLibrary(_ response: Bool)
    
}

class HomePresenter: HomePresentationLogic {
    var viewController: HomeDisplayLogic?
    
    // MARK: - Presentation logic
    func presentPublications(_ response: [FiisNews]) {
        viewController?.showPublications(response)
    }
    
//    func presenterTallAndShort(_ list: [[(String,String)]]) {
//        viewController?.showTallAndShort(list)
//    }
    
    func presentPhrase(_ response: HomeModel.FetchPhrase.Response) {
//        viewController?.showPhrase(response.object!)
        HomeModel.phrase = response.object!
    }
    
    func presentItemsLibrary(_ response: Bool) {
        viewController?.showTopics(response)
    }
    
}

