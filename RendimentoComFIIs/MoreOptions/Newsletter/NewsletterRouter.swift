//
//  NewsletterRouter.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

protocol NewsletterRoutingLogic {
    func routeTosegueHomeWithSegue(segue: UIStoryboardSegue?)
}

protocol NewsletterDataPassing {
    var dataStore: NewsletterDataStore? { get set}
}

class NewsletterRouter: NSObject, NewsletterRoutingLogic, NewsletterDataPassing {
    weak var viewController: NewsletterViewController?
    var dataStore: NewsletterDataStore?
    
    // MARK: Routing
    
    func routeTosegueHomeWithSegue(segue: UIStoryboardSegue?) {
//        if segue != nil {
//            let destinationVC = NewsletterViewController()
//            var destinationDS = destinationVC.router!.dataStore!
//            passDataToHome(source: dataStore!, destination: &destinationDS)
//        } else {
            let storyboard = UIStoryboard(name: "NewsletterStoryboard", bundle: nil)
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "home") as! NewsletterViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToNewsletter(source: dataStore!, destination: &destinationDS)
            navigateToNewsletter(source: viewController!, destination: destinationVC)
        
//        }
        
    }
    
    //    MARK: Navigation
    
    func navigateToNewsletter(source: NewsletterViewController, destination: NewsletterViewController) {
        source.segueTo(destination: destination)
    }
    
    //    MARK: Passing data
    
    func passDataToNewsletter(source: NewsletterDataStore, destination: inout NewsletterDataStore) {
        destination.something = source.something
    }
}
