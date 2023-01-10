//
//  InitializationInteractor.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

protocol InitializationBusinessLogic {
    func getQuotes()
    func getIndexIFIX()
    func getIndexes()
    func getNewOrUpdatedItem()
    func getUserData()
    func getMessages(type: TypeMessage)
    func getBasicSalary()
    func getNewsletter()
}

protocol InitializationDataStore {
    var something: String! { get set }
}

class InitializationInteractor: InitializationBusinessLogic, InitializationDataStore {
    var something: String!
    var worker = InitializationWorker()
    var presenter: InitializationPresentationLogic?
    
    func getQuotes() {
        worker.fetchQuotes(complete: { response in
            //
        })
    }
    
    func getIndexIFIX() {
        worker.fetchIFIX(success: {response in
            //
        }, fail: { response in
            //
        })
    }
    
    func getIndexes() {
        worker.fetchIndexes()
    }
    
    func getNewOrUpdatedItem() {
        worker.fetchNewOrUpdatedItem(complete: { response in
            self.presenter?.presentNewOrUpdatedItem(response as! [(ItemsLibrary, Bool)])
        })
    }
    
    func getUserData() {
        worker.fetchUserData { response in
            self.presenter?.presentHomeViewController()
        }
    }
    
    func getMessages(type: TypeMessage) {
        switch type {
        case .sent:
            break
            
        case .received:
            worker.fetchInBaseDataInboxMessages(complete: { response in
//                self.presenter?.presentMessages(response: response)
                InitializationModel.listMessagesReceived = response
            })
        }
        
    }
    
    func getBasicSalary() {
        guard let salary = (UserDefaultKeys.basicSalary.getValue() as! [String:Int]).first?.value, salary <= 0 else { return }
        worker.fetchBasicSalary()
    }
    
    func getNewsletter() {
        worker.fetchNewsletter()
    }
    
}
