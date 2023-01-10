//
//  AboutAppWorker.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import Foundation
import UIKit

typealias responseHandlerAboutApp = (_ response: AboutAppModel.Fetch.Response) ->()

class AboutAppWorker {
    
    init() {
        ConfigureDataBase.instance.clearPersistence()
    }
    
    func fetch(complete:@escaping(responseHandlerAboutApp)) {
        let ref = ConfigureDataBase.instance.collection(ConfigureDataBase.collectionParameters).document(ConfigureDataBase.documentAboutApp)
        ref.getDocument { document, error in
            if let document = document, document.exists {
                AboutAppModel.Fetch.AboutApp.description = document.data()?["description"] as? String ?? ""
                complete(.init(object: .init(), isError: false, message: nil))
            } else {
                complete(.init(object: .init(), isError: true, message: error?.localizedDescription))
            }
        }
        
    }
    
}
