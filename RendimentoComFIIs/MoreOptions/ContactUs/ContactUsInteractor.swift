//
//  ContactUsInteractor.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

protocol ContactUsBusinessLogic {
    func saveMessage(_ objMessage: ContactUsModel.Fetch.Request?)
}

protocol ContactUsDataStore {
    var something: String! { get set }
}

class ContactUsInteractor: ContactUsBusinessLogic, ContactUsDataStore {
    var something: String!
    var worker: ContactUsWorker?
    var presenter: ContactUsPresentationLogic?
    
    func saveMessage(_ objMessage: ContactUsModel.Fetch.Request?) {
        worker = ContactUsWorker()
        if validateMessage(objMessage) {
            if Util.isValidEmail(objMessage?.object.email ?? "") {
                worker?.createInDateBase(request: objMessage ?? .init(object: .init(typeTitle: .other, message: "")), complete: { response in
                    response ? self.presenter?.presentSuccess(NSLocalizedString("send_success", comment: "")) : self.presenter?.presentError(NSLocalizedString("send_error", comment: ""))
                })
            } else {
                presenter?.presentError(NSLocalizedString("error_email", comment: ""))
            }
        } else {
            let msg_error = objMessage?.object.typeTitle == .pix && objMessage?.object.attach?.isEmpty ?? true ? "send_pix" : "error_info_empty"
            self.presenter?.presentError(NSLocalizedString(msg_error, comment: ""))
        }
    }
    
    private func validateMessage(_ obj: ContactUsModel.Fetch.Request?) -> Bool {
        if obj?.object.typeTitle == .pix, obj?.object.attach?.isEmpty ?? true { return false}
        guard let name = obj?.object.name, let email = obj?.object.email, let msg = obj?.object.message else { return false }
        if name.isEmpty || email.isEmpty || (msg.isEmpty || msg.contains(NSLocalizedString("message", comment: "").prefix(15))) {
            return false
        }
        return true
    }
}
