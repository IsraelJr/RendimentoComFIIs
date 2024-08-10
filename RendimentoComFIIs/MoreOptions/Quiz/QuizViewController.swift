//
//  ViewController.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

protocol QuizDisplayLogic {
    func showSomething(_ object: QuizModel.Fetch.Question)
}


class QuizViewController: UIViewController, QuizDisplayLogic {

    var interactor: QuizBusinessLogic?
    var router: (NSObjectProtocol & QuizRoutingLogic & QuizDataPassing)?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let interactor = QuizInteractor()
        let presenter = QuizPresenter()
        let router = QuizRouter()
        
        self.interactor = interactor
        self.router = router
        interactor.presenter = presenter
        presenter.viewController = self
        router.viewController = self
        router.dataStore = interactor
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let scene = segue.identifier {
//            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
//            if let router = router, router.responds(to: selector) {
//                router.perform(selector, with: segue)
//            }
//        }
//        router?.routeTosegueHomeWithSegue(segue: segue)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupLayout()
    }
    
    private func setupLayout() {
        var q1 = QuizModel.Fetch.Question(id: 1, question: "Pergunta numero 1", answers: [(id: 1, response: "Resposta 1"), (id: 2, response: "Resposta 2")], correctAnswer: 2)
        var q2 = QuizModel.Fetch.Question(id: 2, question: "Pergunta numero 2", answers: [(id: 1, response: "Resposta 2.1"), (id: 2, response: "Resposta 2.2")], correctAnswer: 1)
        var list = [QuizModel.Fetch.Question]()
        list.append(q1)
        list.append(q2)
        initialize(quiz: list)
        
        
    }

    func showSomething(_ object: QuizModel.Fetch.Question) {
        
    }
    
    func initialize(quiz: [QuizModel.Fetch.Question]) {
        print("[Quiz]: Inicializando...")
        print("[Quiz]: ====================")
        quiz.forEach { print("[Quiz]: \($0)")}
        print("[Quiz]: ====================")
        print("[Quiz]: Finalizando...")
    }

}

