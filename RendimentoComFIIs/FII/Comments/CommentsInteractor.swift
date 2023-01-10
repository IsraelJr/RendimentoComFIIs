//
//  CommentsInteractor.swift
//  RendimentoComFII
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

protocol CommentsBusinessLogic {
    func getCodeFii()
    func doSomething()
}

protocol CommentsDataStore {
    var codeFii: String! { get set }
}

class CommentsInteractor: CommentsBusinessLogic, CommentsDataStore {
    var codeFii: String!
    var worker: CommentsWorker?
    var presenter: CommentsPresentationLogic?
    
    func getCodeFii() {
        self.presenter?.setCodeFii(codeFii ?? "")
    }
    func doSomething() {
        worker = CommentsWorker()
        worker?.doSomething(request: codeFii ?? "", success: { response in
            self.presenter?.presentSomething(response: response)
        }, fail: { response in
            self.presenter?.presentSomething(response: response)
        })
    }
    
}
