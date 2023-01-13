//
//  PublicRouter.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

protocol PublicRoutingLogic {
    func routeTosegueHomeWithSegue(segue: UIStoryboardSegue?)
}

protocol PublicDataPassing {
    var dataStore: PublicDataStore? { get set}
}

class PublicRouter: NSObject, PublicRoutingLogic, PublicDataPassing {
    weak var viewController: PublicViewController?
    var dataStore: PublicDataStore?
    
    // MARK: Routing
    
    func routeTosegueHomeWithSegue(segue: UIStoryboardSegue?) {
//        if segue != nil {
//            let destinationVC = PublicViewController()
//            var destinationDS = destinationVC.router!.dataStore!
//            passDataToHome(source: dataStore!, destination: &destinationDS)
//        } else {
            let storyboard = UIStoryboard(name: "PublicStoryboard", bundle: nil)
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "home") as! PublicViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToPublic(source: dataStore!, destination: &destinationDS)
            navigateToPublic(source: viewController!, destination: destinationVC)
        
//        }
        
    }
    
    //    MARK: Navigation
    
    func navigateToPublic(source: PublicViewController, destination: PublicViewController) {
        source.segueTo(destination: destination)
    }
    
    //    MARK: Passing data
    
    func passDataToPublic(source: PublicDataStore, destination: inout PublicDataStore) {
        destination.something = source.something
    }
}
