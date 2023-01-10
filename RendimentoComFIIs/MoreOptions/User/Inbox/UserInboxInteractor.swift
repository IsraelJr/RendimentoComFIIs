//
//  UserInboxInteractor.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

protocol UserInboxBusinessLogic {
    func deleteMessage(request: UserInboxModel.Fetch.Message, _ listMessage: [UserInboxModel.Fetch.Message]?)
    func getMessages(type: TypeMessage)
    func markAsRead(request: UserInboxModel.Fetch.Message)
}

protocol UserInboxDataStore {
    var something: String! { get set }
}

class UserInboxInteractor: UserInboxBusinessLogic, UserInboxDataStore {
    var something: String!
    var worker: UserInboxWorker?
    var presenter: UserInboxPresentationLogic?
    
    func deleteMessage(request: UserInboxModel.Fetch.Message, _ listMessage: [UserInboxModel.Fetch.Message]?) {
        worker = UserInboxWorker()
        worker?.delete(request: request, listMessage, complete: { response in
            self.presenter?.presentResultDelete(response: response)
        })
        print(#function)
    }
    
    func getMessages(type: TypeMessage) {
        worker = UserInboxWorker()
        switch type {
        case .sent:
            worker?.fetchInDeviceSentMessages(complete: { response in
                self.presenter?.presentMessages(response: response)
            })
            
        case .received:
            !InitializationModel.listMessagesReceived.isEmpty ? presenter?.presentMessages(response: InitializationModel.listMessagesReceived) : nil
        }
        
    }
    
    func markAsRead(request: UserInboxModel.Fetch.Message) {
        worker = UserInboxWorker()
        worker?.read(request: request.idBD, complete: { response in
            print(#function)
        })
    }
}
