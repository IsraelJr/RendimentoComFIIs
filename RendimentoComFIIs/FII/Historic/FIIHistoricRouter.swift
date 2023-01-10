//
//  FIIHistoricRouter.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

protocol FIIHistoricRoutingLogic {
    func routeTosegueHomeWithSegue(segue: UIStoryboardSegue?)
}

protocol FIIHistoricDataPassing {
    var dataStore: FIIHistoricDataStore? { get set}
}

class FIIHistoricRouter: NSObject, FIIHistoricRoutingLogic, FIIHistoricDataPassing {
    weak var viewController: FIIHistoricViewController?
    var dataStore: FIIHistoricDataStore?
    
    // MARK: Routing
    
    func routeTosegueHomeWithSegue(segue: UIStoryboardSegue?) {
//        if segue != nil {
//            let destinationVC = FIIHistoricViewController()
//            var destinationDS = destinationVC.router!.dataStore!
//            passDataToHome(source: dataStore!, destination: &destinationDS)
//        } else {
            let storyboard = UIStoryboard(name: "FIIHistoricStoryboard", bundle: nil)
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "home") as! FIIHistoricViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToFIIHistoric(source: dataStore!, destination: &destinationDS)
            navigateToFIIHistoric(source: viewController!, destination: destinationVC)
        
//        }
        
    }
    
    //    MARK: Navigation
    
    func navigateToFIIHistoric(source: FIIHistoricViewController, destination: FIIHistoricViewController) {
        source.segueTo(destination: destination)
    }
    
    //    MARK: Passing data
    
    func passDataToFIIHistoric(source: FIIHistoricDataStore, destination: inout FIIHistoricDataStore) {
        destination.code = source.code
    }
}
