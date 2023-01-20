//
//  ListWalletPublicWorker.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import Foundation
import UIKit

typealias responseHandlerListWalletPublic = (_ response: [ListWalletPublicModel.Fetch.ListWalletPublic]) ->()

class ListWalletPublicWorker {
    init() {
        ConfigureDataBase.instance.clearPersistence()
    }
    
    func read(complete:@escaping(responseHandlerListWalletPublic)) {
        ConfigureDataBase.instance.collection(ConfigureDataBase.collectionPublicWallet).whereField("visible", isEqualTo: true).getDocuments { querySnapshot, error in
            var list = [ListWalletPublicModel.Fetch.ListWalletPublic]()
            if error == nil {
                for document in querySnapshot!.documents {
                    list.append(
                        ListWalletPublicModel.Fetch.ListWalletPublic(
                            id: document.documentID
                            ,rating: WalletRating(rawValue: document.data()["rating"] as? String ?? "conservative")
                            ,description: document.data()["description"] as? String
                            ,fiis: (document.data()["fiis"] as! [String:String])
                            ,segments: (document.data()["segments"] as! [String:String]))
                    )
                }
                complete(list)
            } else {
                complete(list)
            }
        }
    }
    
}
