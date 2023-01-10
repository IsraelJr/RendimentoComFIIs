//
//  FIIRouter.swift
//  RendimentoComFII
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

protocol FIIRoutingLogic {
    func routeTosegueCommentsWithSegue(segue: UIStoryboardSegue?)
    func routeTosegueHistoricWithSegue(segue: UIStoryboardSegue?)
}

protocol FIIDataPassing {
    var dataStore: FIIDataStore? { get set}
}

class FIIRouter: NSObject, FIIRoutingLogic, FIIDataPassing {
    weak var viewController: FIIViewController?
    var dataStore: FIIDataStore?
    
    // MARK: Routing
    
    func routeTosegueCommentsWithSegue(segue: UIStoryboardSegue?) {
//        if segue != nil {
//            let destinationVC = FIIViewController()
//            var destinationDS = destinationVC.router!.dataStore!
//            passDataToHome(source: dataStore!, destination: &destinationDS)
//        } else {
            let storyboard = UIStoryboard(name: "CommentsStoryboard", bundle: nil)
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "comments") as! CommentsViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToComments(source: dataStore!, destination: &destinationDS)
            navigateToComments(source: viewController!, destination: destinationVC)
        
//        }
        
    }
    
    func routeTosegueHistoricWithSegue(segue: UIStoryboardSegue?) {
            let storyboard = UIStoryboard(name: "FIIStoryboard", bundle: nil)
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "historic") as! FIIHistoricViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToHistoric(source: dataStore!, destination: &destinationDS)
            navigateToHistoric(source: viewController!, destination: destinationVC)
    }
    
    //    MARK: Navigation
    
    func navigateToComments(source: FIIViewController, destination: CommentsViewController) {
        source.segueTo(destination: destination)
    }
    
    //    MARK: Passing data
    
    func passDataToComments(source: FIIDataStore, destination: inout CommentsDataStore) {
        destination.codeFii = source.fii.code
    }
    
    func navigateToHistoric(source: FIIViewController, destination: FIIHistoricViewController) {
        source.segueTo(destination: destination)
    }
    
    //    MARK: Passing data
    
    func passDataToHistoric(source: FIIDataStore, destination: inout FIIHistoricDataStore) {
        destination.code = source.fii.code
    }
}
