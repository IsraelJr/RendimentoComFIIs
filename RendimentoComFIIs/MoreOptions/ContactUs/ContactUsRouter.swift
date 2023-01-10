//
//  ContactUsRouter.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

protocol ContactUsRoutingLogic {
    func routeTosegueHomeWithSegue(segue: UIStoryboardSegue?)
}

protocol ContactUsDataPassing {
    var dataStore: ContactUsDataStore? { get set}
}

class ContactUsRouter: NSObject, ContactUsRoutingLogic, ContactUsDataPassing {
    weak var viewController: ContactUsViewController?
    var dataStore: ContactUsDataStore?
    
    // MARK: Routing
    
    func routeTosegueHomeWithSegue(segue: UIStoryboardSegue?) {
//        if segue != nil {
//            let destinationVC = ContactUsViewController()
//            var destinationDS = destinationVC.router!.dataStore!
//            passDataToHome(source: dataStore!, destination: &destinationDS)
//        } else {
            let storyboard = UIStoryboard(name: "ContactUsStoryboard", bundle: nil)
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "home") as! ContactUsViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToContactUs(source: dataStore!, destination: &destinationDS)
            navigateToContactUs(source: viewController!, destination: destinationVC)
        
//        }
        
    }
    
    //    MARK: Navigation
    
    func navigateToContactUs(source: ContactUsViewController, destination: ContactUsViewController) {
        source.segueTo(destination: destination)
    }
    
    //    MARK: Passing data
    
    func passDataToContactUs(source: ContactUsDataStore, destination: inout ContactUsDataStore) {
        destination.something = source.something
    }
}
