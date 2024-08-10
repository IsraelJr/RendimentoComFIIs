//
//  QuizRouter.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

protocol QuizRoutingLogic {
    func routeTosegueHomeWithSegue(segue: UIStoryboardSegue?)
}

protocol QuizDataPassing {
    var dataStore: QuizDataStore? { get set}
}

class QuizRouter: NSObject, QuizRoutingLogic, QuizDataPassing {
    weak var viewController: QuizViewController?
    var dataStore: QuizDataStore?
    
    // MARK: Routing
    
    func routeTosegueHomeWithSegue(segue: UIStoryboardSegue?) {
//        if segue != nil {
//            let destinationVC = QuizViewController()
//            var destinationDS = destinationVC.router!.dataStore!
//            passDataToHome(source: dataStore!, destination: &destinationDS)
//        } else {
            let storyboard = UIStoryboard(name: "QuizStoryboard", bundle: nil)
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "home") as! QuizViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToQuiz(source: dataStore!, destination: &destinationDS)
            navigateToQuiz(source: viewController!, destination: destinationVC)
        
//        }
        
    }
    
    //    MARK: Navigation
    
    func navigateToQuiz(source: QuizViewController, destination: QuizViewController) {
        source.segueTo(destination: destination)
    }
    
    //    MARK: Passing data
    
    func passDataToQuiz(source: QuizDataStore, destination: inout QuizDataStore) {
        destination.something = source.something
    }
}
