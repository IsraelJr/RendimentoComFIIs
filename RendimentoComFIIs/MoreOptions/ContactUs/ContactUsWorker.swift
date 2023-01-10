//
//  ContactUsWorker.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import Foundation
import UIKit
import FirebaseFirestore

typealias responseHandlerContactUs = (_ response: ContactUsModel.Fetch.Response) ->()

class ContactUsWorker {
    
    init() {
        ConfigureDataBase.instance.clearPersistence()
    }
    
    func createInDateBase(request: ContactUsModel.Fetch.Request!, complete:@escaping(responseDone)) {
        let doc = ConfigureDataBase.instance.collection(ConfigureDataBase.collectionUser).document(request.object.email?.lowercased() ?? "")
        doc.getDocument { document, error in
            if error == nil {
                let ref = doc.collection(ConfigureDataBase.collectionUserMessage).addDocument(data: [
                    "typeTitle":request.object.typeTitle.rawValue,
                    "message":request.object.message ?? "",
                    "inserted_in":FieldValue.serverTimestamp(),
                    "read":false,
                    "answered":false,
                    "attach":request.object.attach ?? "",
                    "typeMessage":request.object.typeMessage.rawValue
                ])
                self.saveInDevice(.init(id: ref.documentID, name: DataUser.name, email: nil, typeTitle: request.object.typeTitle, message: request.object.message ?? "", attach: nil))
                complete(true)
            } else {
                complete(false)
            }
        }
    }
    
    func saveInDevice(_ message: ContactUsModel.Fetch.ContactUs) {
        DispatchQueue.main.async {
            UserDefaultKeys.sentMessage.setValue(value: message)
        }
    }
}
