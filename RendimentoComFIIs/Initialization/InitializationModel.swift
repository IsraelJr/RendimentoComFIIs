//
//  InitializationModel.swift
//  Pods
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

enum MarketIndex: String, CaseIterable {
    case ipca
    case inpc
    case igpm
    case cdi
    case selic = "taxa-selic"
}

struct InitializationModel: Decodable {
    static let systemName = (Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String) ?? "Rendimento com FIIs"
    static var isFirstAccessOfTheDay = false
    static var customTimeInterval: TimeInterval = 30
    static var dataIfix: InitializationModel.FetchIFIX.IFIX!
    static var dataIndexes: InitializationModel.FetchIndexes.Indexes!
    static var arrayFlagNewOrUpdatedItem = [(ItemsLibrary, Bool)]()
    static var listMessagesReceived = [UserInboxModel.Fetch.Message]()
    
    
    struct Fetch {
        struct Request {
            var object: Initialization!
        }
        struct Response {
            var object: Initialization?
            var isError: Bool!
            var message: String?
        }
        struct Initialization {
            var id: String?
        }
    }
    
    struct FetchIFIX {
        struct Request {
            var url = "https://www.infomoney.com.br/cotacoes/b3/indice/ifix/"
        }
        struct Response {
            var object: IFIX?
            var isError: Bool!
            var message: String?
        }
        struct IFIX {
            var points: String?
            var percent: String?
            var minimum: String?
            var maximum: String?
            var dateUpdate: String?
        }
    }
    
    struct FetchIndexes {
        struct Request {
            var url = "https://www.melhorcambio.com/"
        }
        struct Response {
            var object: Indexes?
            var isError: Bool!
            var message: String?
        }
        struct Indexes {
            var ipca:   (twelveMonths: String, months: [[String:String]], currentYear: String)?
            var inpc:   (twelveMonths: String, months: [[String:String]], currentYear: String)?
            var igpm:   (twelveMonths: String, months: [[String:String]], currentYear: String)?
            var cdi:    (twelveMonths: String, months: [[String:String]], currentYear: String)?
            var selic:  (today: String, currentMonth: String, yearCurrently: String, annualGoal: (year: String, value: String))?
        }
    }
    
    
}
