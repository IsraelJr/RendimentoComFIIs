//
//  WalletHistoricRouter.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

protocol WalletHistoricRoutingLogic {
    func routeTosegueHomeWithSegue(segue: UIStoryboardSegue?)
}

protocol WalletHistoricDataPassing {
    var dataStore: WalletHistoricDataStore? { get set}
}

class WalletHistoricRouter: NSObject, WalletHistoricRoutingLogic, WalletHistoricDataPassing {
    weak var viewController: WalletHistoricViewController?
    var dataStore: WalletHistoricDataStore?
    
    // MARK: Routing
    
    func routeTosegueHomeWithSegue(segue: UIStoryboardSegue?) {
//        if segue != nil {
//            let destinationVC = WalletHistoricViewController()
//            var destinationDS = destinationVC.router!.dataStore!
//            passDataToHome(source: dataStore!, destination: &destinationDS)
//        } else {
            let storyboard = UIStoryboard(name: "WalletHistoricStoryboard", bundle: nil)
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "home") as! WalletHistoricViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToWalletHistoric(source: dataStore!, destination: &destinationDS)
            navigateToWalletHistoric(source: viewController!, destination: destinationVC)
        
//        }
        
    }
    
    //    MARK: Navigation
    
    func navigateToWalletHistoric(source: WalletHistoricViewController, destination: WalletHistoricViewController) {
        source.segueTo(destination: destination)
    }
    
    //    MARK: Passing data
    
    func passDataToWalletHistoric(source: WalletHistoricDataStore, destination: inout WalletHistoricDataStore) {
        destination.something = source.something
    }
}
