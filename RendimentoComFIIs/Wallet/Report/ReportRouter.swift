//
//  ReportRouter.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

protocol ReportRoutingLogic {
    func routeTosegueHomeWithSegue(segue: UIStoryboardSegue?)
}

protocol ReportDataPassing {
    var dataStore: ReportDataStore? { get set}
}

class ReportRouter: NSObject, ReportRoutingLogic, ReportDataPassing {
    weak var viewController: ReportViewController?
    var dataStore: ReportDataStore?
    
    // MARK: Routing
    
    func routeTosegueHomeWithSegue(segue: UIStoryboardSegue?) {
//        if segue != nil {
//            let destinationVC = ReportViewController()
//            var destinationDS = destinationVC.router!.dataStore!
//            passDataToHome(source: dataStore!, destination: &destinationDS)
//        } else {
            let storyboard = UIStoryboard(name: "ReportStoryboard", bundle: nil)
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "home") as! ReportViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToReport(source: dataStore!, destination: &destinationDS)
            navigateToReport(source: viewController!, destination: destinationVC)
        
//        }
        
    }
    
    //    MARK: Navigation
    
    func navigateToReport(source: ReportViewController, destination: ReportViewController) {
        source.segueTo(destination: destination)
    }
    
    //    MARK: Passing data
    
    func passDataToReport(source: ReportDataStore, destination: inout ReportDataStore) {
        destination.something = source.something
    }
}
