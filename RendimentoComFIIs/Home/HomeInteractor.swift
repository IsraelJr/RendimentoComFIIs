//
//  HomeInteractor.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

protocol HomeBusinessLogic {
    func setFii(_ fii: FIIModel.Fetch.FII)
    func setItemLibrary(_ item: String!)
    func getPublications(_ sites: [Sites])
    func getTallAndShort()
    func getPhrase()
    func getItemsLibrary()
}

protocol HomeDataStore {
    var fii: FIIModel.Fetch.FII! { get set }
    var itemLibrary: ItemsLibrary? { get set }
}

class HomeInteractor: HomeBusinessLogic, HomeDataStore {
    var fii: FIIModel.Fetch.FII!
    var itemLibrary: ItemsLibrary?
    var worker: HomeWorker?
    var presenter: HomePresentationLogic?
    
    func setFii(_ fii: FIIModel.Fetch.FII) {
        self.fii = fii
    }
    
    func setItemLibrary(_ item: String!) {
        switch item {
        case ItemsLibrary.glossary.description():
            itemLibrary = .glossary
            
        case ItemsLibrary.books.description():
            itemLibrary = .books
            
        case ItemsLibrary.courses.description():
            itemLibrary = .courses
            
        case ItemsLibrary.brokers.description():
            itemLibrary = .brokers
            
        case ItemsLibrary.tax.description():
            itemLibrary = .tax
            
        default:
            break
        }
    }
    
    func getPublications(_ sites: [Sites]) {
        worker = HomeWorker()
        DispatchQueue.main.async {
            self.worker?.fetchPublications(request: sites, result: { response in
                self.presenter?.presentPublications(response)
            })
        }
    }
    
    func getTallAndShort() {
        //        worker = HomeWorker()
        //        worker?.fetchTallAndShort(complete: { complete in
        //            self.presenter?.presenterTallAndShort(complete)
        //        })
        HomeWorker().fetchTallAndShort()
    }
    
    func getPhrase() {
        worker = HomeWorker()
        worker?.fetchPhrase(success: { response in
            self.presenter?.presentPhrase(response)
        }, fail: { response in
            self.presenter?.presentPhrase(response)
        })
    }
    
    func getItemsLibrary() {
        worker = HomeWorker()
        worker?.fetchImageItemsLibrary(complete: { response in
            self.presenter?.presentItemsLibrary(response)
        })
    }
    
}
