//
//  MoreOptionsRouter.swift
//  RendimentoComFII
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

enum ToVC: String {
    case ContactUs
    case UserProfile
    case AboutApp
    case Newsletter
    case SettingsApp
}

protocol MoreOptionsRoutingLogic {
    func routeTosegueDetailWithSegue(segue: UIStoryboardSegue?)
    func routeToViewController(to: ToVC)
}

protocol MoreOptionsDataPassing {
    var dataStore: MoreOptionsDataStore? { get set}
}

class MoreOptionsRouter: NSObject, MoreOptionsRoutingLogic, MoreOptionsDataPassing {
    weak var viewController: MoreOptionsViewController?
    var dataStore: MoreOptionsDataStore?
    
    // MARK: Routing
    
    func routeTosegueDetailWithSegue(segue: UIStoryboardSegue?) {
//        if segue != nil {
//            let destinationVC = MoreOptionsViewController()
//            var destinationDS = destinationVC.router!.dataStore!
//            passDataToHome(source: dataStore!, destination: &destinationDS)
//        } else {
            let storyboard = UIStoryboard(name: "DetailStoryboard", bundle: nil)
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "detail") as! DetailViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToDetail(source: dataStore!, destination: &destinationDS)
            navigateToDetail(source: viewController!, destination: destinationVC)
        
//        }
        
    }
    
    //    MARK: Navigation
    
    func navigateToDetail(source: MoreOptionsViewController, destination: DetailViewController) {
        source.segueTo(destination: destination)
    }
    
    //    MARK: Passing data
    
    func passDataToDetail(source: MoreOptionsDataStore, destination: inout DetailDataStore) {
        destination.item = source.item
    }
    
    func routeToViewController(to: ToVC) {
        let storyboard = UIStoryboard(name: "\(to.rawValue)Storyboard", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: to.rawValue.lowercased())
        switch to {
        case .AboutApp:
            navigateToViewController(source: viewController!, destination: destinationVC as! AboutAppViewController)
            
        case .ContactUs:
            navigateToViewController(source: viewController!, destination: destinationVC as! ContactUsViewController)
            
        case .UserProfile:
            navigateToViewController(source: viewController!, destination: destinationVC as! UserProfileViewController)
            
        case .Newsletter:
            navigateToViewController(source: viewController!, destination: destinationVC as! NewsletterViewController)
        
        case .SettingsApp:
            navigateToViewController(source: viewController!, destination: destinationVC as! SettingsAppViewController)
            
        }
//        var destinationDS = destinationVC.router!.dataStore!
//        passDataToContactUs(source: dataStore!, destination: &destinationDS)
    }
    
    func navigateToViewController(source: MoreOptionsViewController, destination: UIViewController) {
        source.segueTo(destination: destination)
    }
    
    //    MARK: Passing data
    
//    func passDataToContactUs(source: MoreOptionsDataStore, destination: inout ContactUsDataStore) {
////        destination.something = source.item.rawValue
//    }
    
    
}
