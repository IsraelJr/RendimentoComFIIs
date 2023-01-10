//
//  SettingsAppRouter.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

protocol SettingsAppRoutingLogic {
    func routeTosegueHomeWithSegue(segue: UIStoryboardSegue?)
}

protocol SettingsAppDataPassing {
    var dataStore: SettingsAppDataStore? { get set}
}

class SettingsAppRouter: NSObject, SettingsAppRoutingLogic, SettingsAppDataPassing {
    weak var viewController: SettingsAppViewController?
    var dataStore: SettingsAppDataStore?
    
    // MARK: Routing
    
    func routeTosegueHomeWithSegue(segue: UIStoryboardSegue?) {
//        if segue != nil {
//            let destinationVC = SettingsAppViewController()
//            var destinationDS = destinationVC.router!.dataStore!
//            passDataToHome(source: dataStore!, destination: &destinationDS)
//        } else {
            let storyboard = UIStoryboard(name: "SettingsAppStoryboard", bundle: nil)
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "home") as! SettingsAppViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToSettingsApp(source: dataStore!, destination: &destinationDS)
            navigateToSettingsApp(source: viewController!, destination: destinationVC)
        
//        }
        
    }
    
    //    MARK: Navigation
    
    func navigateToSettingsApp(source: SettingsAppViewController, destination: SettingsAppViewController) {
        source.segueTo(destination: destination)
    }
    
    //    MARK: Passing data
    
    func passDataToSettingsApp(source: SettingsAppDataStore, destination: inout SettingsAppDataStore) {
        destination.something = source.something
    }
}
