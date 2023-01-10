//
//  ReportInteractor.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

protocol ReportBusinessLogic {

}

protocol ReportDataStore {
    var something: String! { get set }
}

class ReportInteractor: ReportBusinessLogic, ReportDataStore {
    var something: String!
    var worker: ReportWorker?
    var presenter: ReportPresentationLogic?
    
    
}
