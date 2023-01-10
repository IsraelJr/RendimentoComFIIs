//
//  UserInboxRouter.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

protocol UserInboxRoutingLogic {
    func routeTosegueHomeWithSegue(segue: UIStoryboardSegue?)
}

protocol UserInboxDataPassing {
    var dataStore: UserInboxDataStore? { get set}
}

class UserInboxRouter: NSObject, UserInboxRoutingLogic, UserInboxDataPassing {
    weak var viewController: UserInboxViewController?
    var dataStore: UserInboxDataStore?
    
    // MARK: Routing
    
    func routeTosegueHomeWithSegue(segue: UIStoryboardSegue?) {
//        if segue != nil {
//            let destinationVC = UserInboxViewController()
//            var destinationDS = destinationVC.router!.dataStore!
//            passDataToHome(source: dataStore!, destination: &destinationDS)
//        } else {
            let storyboard = UIStoryboard(name: "UserInboxStoryboard", bundle: nil)
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "home") as! UserInboxViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToUserInbox(source: dataStore!, destination: &destinationDS)
            navigateToUserInbox(source: viewController!, destination: destinationVC)
        
//        }
        
    }
    
    //    MARK: Navigation
    
    func navigateToUserInbox(source: UserInboxViewController, destination: UserInboxViewController) {
        source.segueTo(destination: destination)
    }
    
    //    MARK: Passing data
    
    func passDataToUserInbox(source: UserInboxDataStore, destination: inout UserInboxDataStore) {
        destination.something = source.something
    }
}
