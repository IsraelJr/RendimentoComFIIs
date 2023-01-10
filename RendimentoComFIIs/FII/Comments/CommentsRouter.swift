//
//  CommentsRouter.swift
//  RendimentoComFII
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

protocol CommentsRoutingLogic {
    func routeTosegueHomeWithSegue(segue: UIStoryboardSegue?)
}

protocol CommentsDataPassing {
    var dataStore: CommentsDataStore? { get set}
}

class CommentsRouter: NSObject, CommentsRoutingLogic, CommentsDataPassing {
    weak var viewController: CommentsViewController?
    var dataStore: CommentsDataStore?
    
    // MARK: Routing
    
    func routeTosegueHomeWithSegue(segue: UIStoryboardSegue?) {
//        if segue != nil {
//            let destinationVC = CommentsViewController()
//            var destinationDS = destinationVC.router!.dataStore!
//            passDataToHome(source: dataStore!, destination: &destinationDS)
//        } else {
            let storyboard = UIStoryboard(name: "CommentsStoryboard", bundle: nil)
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "home") as! CommentsViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToComments(source: dataStore!, destination: &destinationDS)
            navigateToComments(source: viewController!, destination: destinationVC)
        
//        }
        
    }
    
    //    MARK: Navigation
    
    func navigateToComments(source: CommentsViewController, destination: CommentsViewController) {
        source.showDetailViewController(destination, sender: nil)
    }
    
    //    MARK: Passing data
    
    func passDataToComments(source: CommentsDataStore, destination: inout CommentsDataStore) {
        destination.codeFii = source.codeFii
    }
}
