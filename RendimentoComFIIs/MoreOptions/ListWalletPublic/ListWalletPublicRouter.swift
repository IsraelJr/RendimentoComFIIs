//
//  ListWalletPublicRouter.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

protocol ListWalletPublicRoutingLogic {
    func routeTosegueHomeWithSegue(segue: UIStoryboardSegue?)
}

protocol ListWalletPublicDataPassing {
    var dataStore: ListWalletPublicDataStore? { get set}
}

class ListWalletPublicRouter: NSObject, ListWalletPublicRoutingLogic, ListWalletPublicDataPassing {
    weak var viewController: ListWalletPublicViewController?
    var dataStore: ListWalletPublicDataStore?
    
    // MARK: Routing
    
    func routeTosegueHomeWithSegue(segue: UIStoryboardSegue?) {
//        if segue != nil {
//            let destinationVC = ListWalletPublicViewController()
//            var destinationDS = destinationVC.router!.dataStore!
//            passDataToHome(source: dataStore!, destination: &destinationDS)
//        } else {
            let storyboard = UIStoryboard(name: "ListWalletPublicStoryboard", bundle: nil)
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "home") as! ListWalletPublicViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToListWalletPublic(source: dataStore!, destination: &destinationDS)
            navigateToListWalletPublic(source: viewController!, destination: destinationVC)
        
//        }
        
    }
    
    //    MARK: Navigation
    
    func navigateToListWalletPublic(source: ListWalletPublicViewController, destination: ListWalletPublicViewController) {
        source.segueTo(destination: destination)
    }
    
    //    MARK: Passing data
    
    func passDataToListWalletPublic(source: ListWalletPublicDataStore, destination: inout ListWalletPublicDataStore) {
        destination.something = source.something
    }
}
