//
//  UserProfileWorker.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import Foundation
import UIKit
import FirebaseAuth

typealias responseHandlerUserProfile = (_ response: UserProfileModel.Fetch.Response) ->()

enum DeleteFrom {
    case wallet
    case account
}

class UserProfileWorker {
    
    init() {
        ConfigureDataBase.instance.clearPersistence()
    }
    
    func update() {
        let doc = ConfigureDataBase.instance.collection(ConfigureDataBase.collectionUser).document(DataUser.email ?? "")
        doc.getDocument { document, error in
            if error == nil {
                doc.setData([
                    "name":DataUser.name ?? "",
                    "gender":DataUser.gender ?? ""
                ], merge: true)
            }
        }
    }
    
    func delete(from: DeleteFrom, complete:@escaping(responseDone)) {
        switch from {
        case .wallet:
            WalletWorker().delete()
            complete(true)
            
        case .account:
            deleteData { response in
                complete(response)
            }
        }
        
    }
    
    private func deleteData(complete:@escaping(responseDone)) {
        let user = Auth.auth().currentUser
        user?.delete { error in
            if error != nil {
                complete(false)
            } else {
                Util.resetDefaults()
                ConfigureDataBase.instance.collection(ConfigureDataBase.collectionUser).document(DataUser.email ?? "").delete()
                complete(true)
            }
        }
    }
    
}
