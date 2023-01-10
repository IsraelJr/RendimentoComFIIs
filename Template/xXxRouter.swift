//
//  xXxRouter.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

protocol xXxRoutingLogic {
    func routeTosegueHomeWithSegue(segue: UIStoryboardSegue?)
}

protocol xXxDataPassing {
    var dataStore: xXxDataStore? { get set}
}

class xXxRouter: NSObject, xXxRoutingLogic, xXxDataPassing {
    weak var viewController: xXxViewController?
    var dataStore: xXxDataStore?
    
    // MARK: Routing
    
    func routeTosegueHomeWithSegue(segue: UIStoryboardSegue?) {
//        if segue != nil {
//            let destinationVC = xXxViewController()
//            var destinationDS = destinationVC.router!.dataStore!
//            passDataToHome(source: dataStore!, destination: &destinationDS)
//        } else {
            let storyboard = UIStoryboard(name: "xXxStoryboard", bundle: nil)
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "home") as! xXxViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToxXx(source: dataStore!, destination: &destinationDS)
            navigateToxXx(source: viewController!, destination: destinationVC)
        
//        }
        
    }
    
    //    MARK: Navigation
    
    func navigateToxXx(source: xXxViewController, destination: xXxViewController) {
        source.segueTo(destination: destination)
    }
    
    //    MARK: Passing data
    
    func passDataToxXx(source: xXxDataStore, destination: inout xXxDataStore) {
        destination.something = source.something
    }
}
