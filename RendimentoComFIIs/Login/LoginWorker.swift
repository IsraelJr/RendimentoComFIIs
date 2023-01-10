//
//  LoginWorker.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import Foundation
import UIKit
import FirebaseCore
import GoogleSignIn

typealias responseHandlerTerms = (_ response: LoginModel.FetchTerms.Response) ->()

class LoginWorker {
    
    init() {
        ConfigureDataBase.instance.clearPersistence()
    }
    
    func fetchTerms(complete:@escaping(responseHandlerTerms)) {
        let ref = ConfigureDataBase.instance.collection(ConfigureDataBase.collectionParameters).document(ConfigureDataBase.documentTerms)
        ref.getDocument { document, error in
            if let document = document, document.exists {
                complete(.init(object: .init(title: document.data()?["title"] as? String, description: document.data()?["description"] as? String),
                               isError: false,
                               message: nil))
            } else {
                complete(.init(object: .init(),
                               isError: true,
                               message: error?.localizedDescription))
            }
        }
        
    }
}
