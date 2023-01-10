//
//  HomeRouter.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

protocol HomeRoutingLogic {
    func routeTosegueFIIWithSegue(segue: UIStoryboardSegue?)
    func routeTosegueDetailWithSegue(segue: UIStoryboardSegue?)
}

protocol HomeDataPassing {
    var dataStore: HomeDataStore? { get set}
}

class HomeRouter: NSObject, HomeRoutingLogic, HomeDataPassing {
    weak var viewController: HomeViewController?
    var dataStore: HomeDataStore?
    
    // MARK: Routing
    
    func routeTosegueFIIWithSegue(segue: UIStoryboardSegue?) {
//        if segue != nil {
//            let destinationVC = HomeViewController()
//            var destinationDS = destinationVC.router!.dataStore!
//            passDataToHome(source: dataStore!, destination: &destinationDS)
//        } else {
            let storyboard = UIStoryboard(name: "FIIStoryboard", bundle: nil)
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "fii") as! FIIViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToFII(source: dataStore!, destination: &destinationDS)
            navigateToFII(source: viewController!, destination: destinationVC)
        
//        }
        
    }
    
    func routeTosegueDetailWithSegue(segue: UIStoryboardSegue?) {
        let storyboard = UIStoryboard(name: "DetailStoryboard", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "detail") as! DetailViewController
        var destinationDS = destinationVC.router!.dataStore!
        passDataToDetail(source: dataStore!, destination: &destinationDS)
        navigateToDetail(source: viewController!, destination: destinationVC)
    }
    
    //    MARK: Navigation
    
    func navigateToFII(source: HomeViewController, destination: FIIViewController) {
        source.segueTo(destination: destination)
    }
    
    //    MARK: Passing data
    
    func passDataToFII(source: HomeDataStore, destination: inout FIIDataStore) {
        destination.fii = source.fii
    }
    
    func navigateToDetail(source: HomeViewController, destination: DetailViewController) {
        source.segueTo(destination: destination)
    }
    
    func passDataToDetail(source: HomeDataStore, destination: inout DetailDataStore) {
        destination.itemLibrary = source.itemLibrary
    }
    
}
