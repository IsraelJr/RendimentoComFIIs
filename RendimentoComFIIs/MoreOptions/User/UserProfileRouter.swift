//
//  UserProfileRouter.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

protocol UserProfileRoutingLogic {
    func routeTosegueHomeWithSegue(segue: UIStoryboardSegue?)
}

protocol UserProfileDataPassing {
    var dataStore: UserProfileDataStore? { get set}
}

class UserProfileRouter: NSObject, UserProfileRoutingLogic, UserProfileDataPassing {
    weak var viewController: UserProfileViewController?
    var dataStore: UserProfileDataStore?
    
    // MARK: Routing
    
    func routeTosegueHomeWithSegue(segue: UIStoryboardSegue?) {
//        if segue != nil {
//            let destinationVC = UserProfileViewController()
//            var destinationDS = destinationVC.router!.dataStore!
//            passDataToHome(source: dataStore!, destination: &destinationDS)
//        } else {
            let storyboard = UIStoryboard(name: "UserProfileStoryboard", bundle: nil)
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "home") as! UserProfileViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToUserProfile(source: dataStore!, destination: &destinationDS)
            navigateToUserProfile(source: viewController!, destination: destinationVC)
        
//        }
        
    }
    
    //    MARK: Navigation
    
    func navigateToUserProfile(source: UserProfileViewController, destination: UserProfileViewController) {
        source.segueTo(destination: destination)
    }
    
    //    MARK: Passing data
    
    func passDataToUserProfile(source: UserProfileDataStore, destination: inout UserProfileDataStore) {
        destination.something = source.something
    }
}
