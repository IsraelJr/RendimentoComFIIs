//
//  DetailPresenter.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

protocol DetailPresentationLogic {
    func presentTitleToItem(_ title: MoreOptions?)
    func presentAboutFii(_ response: [(title: String, description: String?)])
    func presentLibrary(_ response: [String])
    func presentGlossary(_ response: DetailModel.FetchGlossary.Response)
    func presentBooks(_ response: DetailModel.FetchBooks.Response)
    func presentCourses(_ response: DetailModel.FetchCourses.Response)
    func presentBrokers(_ response: DetailModel.FetchBrokers.Response)
    func presentTax(_ response: DetailModel.FetchTax.Response)
    
}

class DetailPresenter: DetailPresentationLogic {
    var viewController: DetailDisplayLogic?
    
    // MARK: - Presentation logic
    func presentTitleToItem(_ title: MoreOptions?) {
        viewController?.setTitleToItem(title?.description() ?? "")
    }
    
    func presentAboutFii(_ response: [(title: String, description: String?)]) {
        if response.isEmpty {
            viewController?.showAboutFii(response)
        } else {
            viewController?.showAboutFii(response)
        }
    }
    
    func presentLibrary(_ response: [String]) {
        if response.isEmpty {
            viewController?.showLibrary(response)
        } else {
            viewController?.showLibrary(response)
        }
    }
    
    func presentGlossary(_ response: DetailModel.FetchGlossary.Response) {
        if response.isError {
            viewController?.showGlossary(response.list!)
        } else {
            viewController?.showGlossary(response.list!)
        }
    }
    
    func presentBooks(_ response: DetailModel.FetchBooks.Response) {
        if response.isError {
            viewController?.showBooks(response.list!)
        } else {
            viewController?.showBooks(response.list!)
        }
    }
    
    func presentCourses(_ response: DetailModel.FetchCourses.Response) {
        if response.isError {
            viewController?.showCourses(response.list!)
        } else {
            viewController?.showCourses(response.list!)
        }
    }
    
    func presentBrokers(_ response: DetailModel.FetchBrokers.Response) {
        if response.isError {
            viewController?.showBrokers(response.list!)
        } else {
            viewController?.showBrokers(response.list!)
        }
    }
    
    func presentTax(_ response: DetailModel.FetchTax.Response) {
        if response.isError {
            viewController?.showTax(response.list!)
        } else {
            viewController?.showTax(response.list!)
        }
    }
}

