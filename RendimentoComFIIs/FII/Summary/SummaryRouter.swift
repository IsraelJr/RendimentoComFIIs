//
//  SummaryRouter.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

protocol SummaryRoutingLogic {
    func routeTosegueHomeWithSegue(segue: UIStoryboardSegue?)
}

protocol SummaryDataPassing {
    var dataStore: SummaryDataStore? { get set}
}

class SummaryRouter: NSObject, SummaryRoutingLogic, SummaryDataPassing {
    weak var viewController: SummaryViewController?
    var dataStore: SummaryDataStore?
    
    // MARK: Routing
    
    func routeTosegueHomeWithSegue(segue: UIStoryboardSegue?) {
//        if segue != nil {
//            let destinationVC = SummaryViewController()
//            var destinationDS = destinationVC.router!.dataStore!
//            passDataToHome(source: dataStore!, destination: &destinationDS)
//        } else {
            let storyboard = UIStoryboard(name: "SummaryStoryboard", bundle: nil)
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "home") as! SummaryViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToSummary(source: dataStore!, destination: &destinationDS)
            navigateToSummary(source: viewController!, destination: destinationVC)
        
//        }
        
    }
    
    //    MARK: Navigation
    
    func navigateToSummary(source: SummaryViewController, destination: SummaryViewController) {
        source.segueTo(destination: destination)
    }
    
    //    MARK: Passing data
    
    func passDataToSummary(source: SummaryDataStore, destination: inout SummaryDataStore) {
        destination.something = source.something
    }
}
