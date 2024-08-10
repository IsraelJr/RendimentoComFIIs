//
//  QuizInteractor.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

protocol QuizBusinessLogic {
    func doSomething(request: QuizModel.Fetch.Request)
}

protocol QuizDataStore {
    var something: String! { get set }
}

class QuizInteractor: QuizBusinessLogic, QuizDataStore {
    var something: String!
    var worker: QuizWorker?
    var presenter: QuizPresentationLogic?
    
    func doSomething(request: QuizModel.Fetch.Request) {
        worker = QuizWorker()
        worker?.doSomething(request: request, success: { response in
            self.presenter?.presentSomething(response: response)
        }, fail: { response in
            self.presenter?.presentSomething(response: response)
        })
    }
    
}
