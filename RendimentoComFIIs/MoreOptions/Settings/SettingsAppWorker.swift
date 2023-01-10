//
//  SettingsAppWorker.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import Foundation
import UIKit

typealias responseHandlerSettingsApp = (_ response: SettingsAppModel.Fetch.Response) ->()

class SettingsAppWorker {
    
    init() {
        ConfigureDataBase.instance.clearPersistence()
    }
    
    func save(complete:@escaping(responseHandlerSettingsApp)) {
        let doc = ConfigureDataBase.instance.collection(ConfigureDataBase.collectionUser).document(DataUser.email ?? "")
        doc.getDocument { document, error in
            if error == nil {
                doc.setData(
                    [
                        ConfigureDataBase.fieldWalletPublic:(UserDefaultKeys.wallet_public.getValue() as! Bool)
                    ], merge: true) { error in
                        if error == nil {
                            complete(.init(object: nil, isError: false, message: NSLocalizedString("save_success", comment: "")))
                        } else {
                            complete(.init(object: nil, isError: true, message: NSLocalizedString("save_error", comment: "")))
                        }
                    }
            } else {
                complete(.init(object: nil, isError: true, message: "\(NSLocalizedString("save_error", comment: ""))\n\(error?.localizedDescription ?? "")"))
            }
        }
    }
    
}
