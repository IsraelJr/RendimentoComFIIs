//
//  PublicWorker.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import Foundation
import UIKit

class PublicWorker {
    
    var wp: PublicModel.Fetch.Response?
    
    init() {
        ConfigureDataBase.instance.clearPersistence()
    }
    
    func create(request: PublicModel.Fetch.Request, complete:@escaping(responseDone)) {
        
        var fiis = [String:String]()
        request.object.fiis?.forEach({
            fiis.updateValue($0.1, forKey: $0.0)
        })
        
        var segments = [String:String]()
        request.object.segments?.forEach({
            segments.updateValue($0.1, forKey: $0.0)
        })
        
        ConfigureDataBase.instance.collection(ConfigureDataBase.collectionPublicWallet).document(request.object.id).setData(
            [
                "rating":request.object.rating.rawValue,
                "description":request.object.description!,
                "fiis":fiis,
                "segments":segments,
                "visible":true
            ]
        ) { error in
            error == nil ? complete(true) : complete(false)
        }
    }
    
    func read(complete:@escaping(responseDone)) {
        ConfigureDataBase.instance.collection(ConfigureDataBase.collectionPublicWallet).document(DataUser.email!).getDocument { document, error in
            if let document = document, document.exists {
                self.wp = PublicModel.Fetch.Response(object: PublicModel.Fetch.Public(
                    id: DataUser.email,
                    rating: WalletRating(rawValue: document.data()?["rating"] as? String ?? "conservative"),
                    description: document.data()?["description"] as? String,
                    fiis: document.data()?["fiis"] as? [(String, String)] ?? [("","")],
                    segments: document.data()?["segments"] as? [(String, String)] ?? [("","")]), isError: false, message: nil)
                complete(true)
            } else {
                complete(false)
            }
        }
        
    }
    
    func update(complete:@escaping(responseDone)) {
        //        ConfigureDataBase.instance.collection(ConfigureDataBase.collectionPublicWallet).document(DataUser.email!).delete()
        complete(true)
    }
    
    func delete(complete:@escaping(responseDone)) {
        ConfigureDataBase.instance.collection(ConfigureDataBase.collectionPublicWallet).document(DataUser.email!).delete()
    }
    
    func getWalletPublic() -> PublicModel.Fetch.Response? {
        return wp
    }
}
