//
//  InitializationRouter.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

protocol InitializationRoutingLogic {
    func routeTosegueHomeWithSegue(segue: UIStoryboardSegue?)
}

protocol InitializationDataPassing {
    var dataStore: InitializationDataStore? { get set}
}

class InitializationRouter: NSObject, InitializationRoutingLogic, InitializationDataPassing {
    weak var viewController: InitializationViewController?
    var dataStore: InitializationDataStore?
    
    // MARK: Routing
    
    func routeTosegueHomeWithSegue(segue: UIStoryboardSegue?) {
//        if segue != nil {
//            let destinationVC = InitializationViewController()
//            var destinationDS = destinationVC.router!.dataStore!
//            passDataToHome(source: dataStore!, destination: &destinationDS)
//        } else {
            let storyboard = UIStoryboard(name: "InitializationStoryboard", bundle: nil)
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "home") as! InitializationViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToInitialization(source: dataStore!, destination: &destinationDS)
            navigateToInitialization(source: viewController!, destination: destinationVC)
        
//        }
        
    }
    
    //    MARK: Navigation
    
    func navigateToInitialization(source: InitializationViewController, destination: InitializationViewController) {
        source.segueTo(destination: destination)
    }
    
    //    MARK: Passing data
    
    func passDataToInitialization(source: InitializationDataStore, destination: inout InitializationDataStore) {
        destination.something = source.something
    }
}
