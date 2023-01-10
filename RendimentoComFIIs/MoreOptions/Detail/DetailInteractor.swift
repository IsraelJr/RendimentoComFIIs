//
//  DetailInteractor.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

protocol DetailBusinessLogic {
    func getSegueToItem()
    func getGlossary()
    func getBooks()
    func getCourses()
    func getBrokers()
    func getTax()
}

protocol DetailDataStore {
    var item: MoreOptions? { get set }
    var itemLibrary: ItemsLibrary? { get set }
}

class DetailInteractor: DetailBusinessLogic, DetailDataStore {
    var item: MoreOptions?
    var itemLibrary: ItemsLibrary?
    var worker: DetailWorker?
    var presenter: DetailPresentationLogic?
    
    func getSegueToItem() {
        presenter?.presentTitleToItem(item)
        switch item {
        case .aboutfii:
            getAboutFii()
            
        case .library:
            getLibrary()
            
        case .archive:
            break
        
        default:
            presenter?.presentTitleToItem(MoreOptions.library)
            switch itemLibrary {
            case .glossary:
                getGlossary()
                
            case .books:
                getBooks()
                
            case .courses:
                getCourses()
                
            case .brokers:
                getBrokers()
                
            case .tax:
                getTax()
                
            default:
                break
            }
        }
    }
    func getAboutFii() {
        worker = DetailWorker()
        worker?.fetchAboutFii(complete: { response in
            self.presenter?.presentAboutFii(response)
        })
    }
 
    func getLibrary() {
        worker = DetailWorker()
        worker?.fetchLibrary(complete: { response in
            self.presenter?.presentLibrary(response as! [String])
        })
    }
    
    func getGlossary() {
        worker = DetailWorker()
        worker?.fetchGlossary(complete: { response in
            self.presenter?.presentGlossary(response)
        })
    }
    
    func getBooks() {
        worker = DetailWorker()
        worker?.fetchBooks(complete: { response in
            self.presenter?.presentBooks(response)
        })
    }
    
    func getCourses() {
        worker = DetailWorker()
        worker?.fetchCourses(complete: { response in
            self.presenter?.presentCourses(response)
        })
    }
    
    func getBrokers() {
        worker = DetailWorker()
        worker?.fetchBrokers(complete: { response in
            self.presenter?.presentBrokers(response)
        })
    }
    
    func getTax() {
        worker = DetailWorker()
        worker?.fetchTax(complete: { response in
            self.presenter?.presentTax(response)
        })
    }
}
