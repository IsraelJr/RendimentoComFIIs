//
//  DetailRouter.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

protocol DetailRoutingLogic {
    func routeTosegueHomeWithSegue(segue: UIStoryboardSegue?)
}

protocol DetailDataPassing {
    var dataStore: DetailDataStore? { get set}
}

class DetailRouter: NSObject, DetailRoutingLogic, DetailDataPassing {
    weak var viewController: DetailViewController?
    var dataStore: DetailDataStore?
    
    // MARK: Routing
    
    func routeTosegueHomeWithSegue(segue: UIStoryboardSegue?) {
//        if segue != nil {
//            let destinationVC = DetailViewController()
//            var destinationDS = destinationVC.router!.dataStore!
//            passDataToHome(source: dataStore!, destination: &destinationDS)
//        } else {
            let _ = UIStoryboard(name: "DetailStoryboard", bundle: nil)
//            let destinationVC = storyboard.instantiateViewController(withIdentifier: "home") as! DetailViewController
//            var destinationDS = destinationVC.router!.dataStore!
//            passDataToDetail(source: dataStore!, destination: &destinationDS)
//            navigateToDetail(source: viewController!, destination: destinationVC)
        
//        }
        
    }
    
    //    MARK: Navigation
    
//    func navigateToDetail(source: DetailViewController, destination: DetailViewController) {
//        source.showDetailViewController(destination, sender: nil)
//    }
//    
//    //    MARK: Passing data
//    
//    func passDataToDetail(source: DetailDataStore, destination: inout DetailDataStore) {
//        destination.something = source.something
//    }
}
