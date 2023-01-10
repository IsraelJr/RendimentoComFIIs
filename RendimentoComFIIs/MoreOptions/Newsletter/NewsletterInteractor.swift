//
//  NewsletterInteractor.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

protocol NewsletterBusinessLogic {
    
}

protocol NewsletterDataStore {
    var something: String! { get set }
}

class NewsletterInteractor: NewsletterBusinessLogic, NewsletterDataStore {
    var something: String!
    var worker: NewsletterWorker?
    var presenter: NewsletterPresentationLogic?
    
    
}
