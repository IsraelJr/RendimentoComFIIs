//
//  PublicWorker.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import Foundation
import UIKit

class PublicWorker {
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
            ]
        ) { error in
                error == nil ? complete(true) : complete(false)
            }
    }
    
    func read(complete:@escaping(responseDone)) {
//        ConfigureDataBase.instance.collection(ConfigureDataBase.collectionPublicWallet).document(DataUser.email!).delete()
        complete(true)
    }
    
    func update(complete:@escaping(responseDone)) {
//        ConfigureDataBase.instance.collection(ConfigureDataBase.collectionPublicWallet).document(DataUser.email!).delete()
        complete(true)
    }
    
    func delete(complete:@escaping(responseDone)) {
        ConfigureDataBase.instance.collection(ConfigureDataBase.collectionPublicWallet).document(DataUser.email!).delete()
    }
    
}
