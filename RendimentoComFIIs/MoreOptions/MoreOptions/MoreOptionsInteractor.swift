//
//  MoreOptionsInteractor.swift
//  RendimentoComFII
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

protocol MoreOptionsBusinessLogic {
    func passToMenu(to item: MoreOptions)
}

protocol MoreOptionsDataStore {
    var item: MoreOptions! { get set }
}

class MoreOptionsInteractor: MoreOptionsBusinessLogic, MoreOptionsDataStore {
    var item: MoreOptions!
    var worker: MoreOptionsWorker?
    var presenter: MoreOptionsPresentationLogic?
    
    func passToMenu(to item: MoreOptions) {
        self.item = item
    }
    
    
//    func doSomething(request: MoreOptionsModel.Fetch.Request) {
//        worker = MoreOptionsWorker()
//        worker?.doSomething(request: request, success: { response in
//            self.presenter?.presentSomething(response: response)
//        }, fail: { response in
//            self.presenter?.presentSomething(response: response)
//        })
//    }
    
}
