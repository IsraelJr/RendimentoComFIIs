//
//  SearchRouter.swift
//  RendimentoComFII
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

protocol SearchRoutingLogic {
    func routeTosegueFIIWithSegue(segue: UIStoryboardSegue?)
}

protocol SearchDataPassing {
    var dataStore: SearchDataStore? { get set}
}

class SearchRouter: NSObject, SearchRoutingLogic, SearchDataPassing {
    weak var viewController: SearchViewController?
    var dataStore: SearchDataStore?
    
    // MARK: Routing
    
    func routeTosegueFIIWithSegue(segue: UIStoryboardSegue?) {
//        if segue != nil {
//            let destinationVC = SearchViewController()
//            var destinationDS = destinationVC.router!.dataStore!
//            passDataToSearch(source: dataStore!, destination: &destinationDS)
//        } else {
            let storyboard = UIStoryboard(name: "FIIStoryboard", bundle: nil)
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "fii") as! FIIViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToFII(source: dataStore!, destination: &destinationDS)
            navigateToFII(source: viewController!, destination: destinationVC)
        
//        }
        
    }
    
    //    MARK: Navigation
    
    func navigateToFII(source: SearchViewController, destination: FIIViewController) {
        source.segueTo(destination: destination)
    }
    
    //    MARK: Passing data
    
    func passDataToFII(source: SearchDataStore, destination: inout FIIDataStore) {
        destination.fii = source.fii
    }
}
