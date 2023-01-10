//
//  UserInboxWorker.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import Foundation
import UIKit
import FirebaseFirestore

typealias responseHandlerSentMessages = (_ response: [UserInboxModel.Fetch.Message]) ->()

class UserInboxWorker {
    
    init() {
        ConfigureDataBase.instance.clearPersistence()
    }
    
    func delete(request: UserInboxModel.Fetch.Message, _ listMessage: [UserInboxModel.Fetch.Message]?, complete:@escaping(responseDone)) {
        let ref = ConfigureDataBase.instance.collection(ConfigureDataBase.collectionUser).document(DataUser.email?.lowercased() ?? "").collection(ConfigureDataBase.collectionUserMessage)
        
        if var list = listMessage, !list.isEmpty {
            ref.whereField(ConfigureDataBase.fieldTypeMessage, in: [list.first!.typeMessage.rawValue]).getDocuments { querySnapshot, error in
                if error == nil {
                    for document in querySnapshot!.documents {
                        document.reference.delete { error in
                            if error == nil {
                                UserDefaults.standard.removeObject(forKey: list.first(where: { $0.idBD.elementsEqual(document.documentID) })?.idLocal ?? "")
                                list.remove(at: list.firstIndex(where: { $0.idBD.elementsEqual(document.documentID) })!)
                                if InitializationModel.listMessagesReceived.contains(where: { $0.idBD.elementsEqual(document.documentID) } ) {
                                    InitializationModel.listMessagesReceived.remove(at: InitializationModel.listMessagesReceived.firstIndex(where: { $0.idBD.elementsEqual(document.documentID) })!)
                                }
                                if list.isEmpty {
                                    complete(true)
                                    return
                                }
                            } else {
                                complete(false)
                                return
                            }
                        }
                    }
                } else {
                    complete(false)
                    return
                }
            }
        } else {
            ref.document(request.idBD).delete { error in
                if error == nil {
                    UserDefaults.standard.removeObject(forKey: request.idLocal)
                    if InitializationModel.listMessagesReceived.contains(where: { $0.idBD.elementsEqual(request.idBD) } ) {
                        InitializationModel.listMessagesReceived.remove(at: InitializationModel.listMessagesReceived.firstIndex(where: { $0.idBD.elementsEqual(request.idBD) })!)
                    }
                    complete(true)
                } else {
                    complete(false)
                }
            }
        }
    }
    
    func fetchInDeviceSentMessages(complete:@escaping(responseHandlerSentMessages)) {
        guard let list = (UserDefaultKeys.sentMessage.getValue() as? [String]) else { complete(.init()); return }
        var sents = [UserInboxModel.Fetch.Message]()
        list.forEach({
            if !$0.isEmpty {
                let date = String($0.split(separator: ";")[3])
                sents.append(UserInboxModel.Fetch.Message.init(
                    idBD: $0.split(separator: ";").last!.description
                    , idLocal: $0.split(separator: ";").first!.description
                    , owner: DataUser.name!
                    , date: date
                    , title: NSLocalizedString(String($0.split(separator: ";")[1]).lowercased(), comment: "").firstLetterUppercased()
                    , description: String($0.split(separator: ";")[2])
                    , typeMessage: .sent
                    , read: true
                ))
            }
        })
        complete(sents)
    }
    
    func read(request: String, complete:@escaping(responseDone)) {
        ConfigureDataBase.instance.collection(ConfigureDataBase.collectionUser).document(DataUser.email?.lowercased() ?? "").collection(ConfigureDataBase.collectionUserMessage).document(request).setData(
            [
                "read":true
                ,"read_in":FieldValue.serverTimestamp()
            ]
            , merge: true) { error in
                if error == nil {
                    var message = InitializationModel.listMessagesReceived.first(where: { $0.idBD.elementsEqual(request) })
                    InitializationModel.listMessagesReceived.removeAll(where: { $0.idBD.elementsEqual(request) })
                    message?.read = true
                    message != nil ? InitializationModel.listMessagesReceived.append(message!) : nil
                    UserDefaultKeys.unread_message.setValue(value: InitializationModel.listMessagesReceived.contains(where: { $0.read == false }))
                    complete(true)
                } else {
                    complete(false)
                }
            }
    }
}
