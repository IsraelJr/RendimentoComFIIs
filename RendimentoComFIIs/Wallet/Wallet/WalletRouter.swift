//
//  WalletRouter.swift
//  RendimentoComFII
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

protocol WalletRoutingLogic {
    func routeTosegueFIIWithSegue(segue: UIStoryboardSegue?)
}

protocol WalletDataPassing {
    var dataStore: WalletDataStore? { get set}
}

class WalletRouter: NSObject, WalletRoutingLogic, WalletDataPassing {
    weak var viewController: WalletViewController?
    var dataStore: WalletDataStore?
    
    // MARK: Routing
    
    func routeTosegueFIIWithSegue(segue: UIStoryboardSegue?) {
//        if segue != nil {
//            let destinationVC = WalletViewController()
//            var destinationDS = destinationVC.router!.dataStore!
//            passDataToWallet(source: dataStore!, destination: &destinationDS)
//        } else {
            let storyboard = UIStoryboard(name: "FIIStoryboard", bundle: nil)
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "fii") as! FIIViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToFII(source: dataStore!, destination: &destinationDS)
            navigateToFII(source: viewController!, destination: destinationVC)
        
//        }
        
    }
    
    //    MARK: Navigation
    
    func navigateToFII(source: WalletViewController, destination: FIIViewController) {
        source.segueTo(destination: destination)
    }
    
    //    MARK: Passing data
    
    func passDataToFII(source: WalletDataStore, destination: inout FIIDataStore) {
        destination.fii = source.fii
    }
    
}
