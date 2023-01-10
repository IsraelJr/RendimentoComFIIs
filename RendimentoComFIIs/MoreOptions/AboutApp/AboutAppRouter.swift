//
//  AboutAppRouter.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

protocol AboutAppRoutingLogic {
    func routeTosegueHomeWithSegue(segue: UIStoryboardSegue?)
}

protocol AboutAppDataPassing {
    var dataStore: AboutAppDataStore? { get set}
}

class AboutAppRouter: NSObject, AboutAppRoutingLogic, AboutAppDataPassing {
    weak var viewController: AboutAppViewController?
    var dataStore: AboutAppDataStore?
    
    // MARK: Routing
    
    func routeTosegueHomeWithSegue(segue: UIStoryboardSegue?) {
//        if segue != nil {
//            let destinationVC = AboutAppViewController()
//            var destinationDS = destinationVC.router!.dataStore!
//            passDataToHome(source: dataStore!, destination: &destinationDS)
//        } else {
            let storyboard = UIStoryboard(name: "AboutAppStoryboard", bundle: nil)
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "home") as! AboutAppViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToAboutApp(source: dataStore!, destination: &destinationDS)
            navigateToAboutApp(source: viewController!, destination: destinationVC)
        
//        }
        
    }
    
    //    MARK: Navigation
    
    func navigateToAboutApp(source: AboutAppViewController, destination: AboutAppViewController) {
        source.segueTo(destination: destination)
    }
    
    //    MARK: Passing data
    
    func passDataToAboutApp(source: AboutAppDataStore, destination: inout AboutAppDataStore) {
        destination.something = source.something
    }
}
