//
//  WalletWorker.swift
//  RendimentoComFII
//
//  Created by Israel Alves on 26/03/22.
//

import Foundation
import UIKit
import FirebaseFirestore

typealias responseHandlerWallet = (_ response: WalletModel.Fetch.Response) ->()

class WalletWorker {
    
    init() {
        ConfigureDataBase.instance.clearPersistence()
    }
    
    func create(request: [(String,Int64)]) {
        let doc = ConfigureDataBase.instance.collection(ConfigureDataBase.collectionUser).document(DataUser.email ?? "")
        doc.getDocument { document, error in
            if error == nil {
                var map = [[String:Int64]]()
                request.forEach({ map.append([$0.0:$0.1]) })
                if document?.data()?["created_in"] == nil {
                    let createdIn = FieldValue.serverTimestamp()
                    doc.setData(["created_in":createdIn], merge: true) { error in
                        error == nil ? UserDefaultKeys.userCreatedIn.setValue(value: createdIn.description) : print(error!.localizedDescription)
                    }
                }
                doc.setData([ConfigureDataBase.fieldUserWallet:map], merge: true) { error in
                    error != nil ? print(error!.localizedDescription) : nil
                }
            }
        }
    }
    
    func read(complete:@escaping(responseHandlerWallet)) {
        let ref = ConfigureDataBase.instance.collection(ConfigureDataBase.collectionUser).document(DataUser.email ?? "")
        ref.getDocument { document, error in
            if let document = document, document.exists {
                let array = document.data()![ConfigureDataBase.fieldUserWallet] as? [[String:Int64]]
                array?.forEach({
                    _ = Util.userDefaultForWallet(action: .create, code: $0.first!.key, quotas: String($0.first!.value))
                })
                let earnings = document.data()!["earnings"] as! [String:Any]?
                complete(.init(object: .init(annualEarnings: earnings, wallet: array), isError: false, message: nil))
            } else {
                complete(.init(object: nil, isError: true, message: ""))
            }
        }
    }
    
    func update(request: [(String,Int64)]) {
        create(request: request)
    }
    
    func delete() {
        ListFii.allFiis().forEach({_ = Util.userDefaultForWallet(action: .delete, code: $0.code)})
        create(request: [(String,Int64)]())
    }
    
    func saveMonthlyEarnings(total: Double, complete:@escaping(responseDone)) {
        let ref = ConfigureDataBase.instance.collection(ConfigureDataBase.collectionUser).document(DataUser.email ?? "")
        ref.getDocument { document, error in
            if error == nil {
                if let document = document, document.exists {
                    ref.setData([
                        "earnings":["\(Util.currentYear)":[
                            Month.current.description().0:total
                        ]]], merge: true)
                    complete(true)
                    return
                } else {
                    complete(false)
                }
            } else {
                complete(false)
            }
        }
    }
    
}
