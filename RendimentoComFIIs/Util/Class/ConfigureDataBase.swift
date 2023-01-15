//
//  ConfigureDataBase.swift
//  RendimentoComFII
//
//  Created by Israel Alves on 30/03/22.
//

import Foundation
import FirebaseFirestore

class ConfigureDataBase {
    static let instance = Firestore.firestore()
    
    static let collectionFiis = "Fiis"
    static let collectionPhrases = "Phrases"
    static let collectionParameters = "Parameters"
    static let collectionAboutFii = "AboutFii"
    static let collectionBooks = "Books"
    static let collectionGlossary = "Glossary"
    static let collectionCourses = "Courses"
    static let collectionBrokers = "Brokers"
    static let collectionTax = "IncomeTax"
    static let collectionLibrary = "Library"
    static let collectionUser = "User"
    static let collectionUserMessage = "Message"
    static let collectionNewsletter = "Newsletter"
    static let collectionPublicWallet = "PublicWallet"
    
    static let documentBasicSalary = "basic_salary"
    static let documentMaintenance = "maintenance"
    static let documentTerms = "terms"
    static let documentAboutApp = "about_app"
    
    static let fieldValueSalary = "value_salary"
    static let fieldActiveDatabase = "active_database"
    static let fieldUserWallet = "wallet"
    static let fieldUserMessage = "message"
    static let fieldWalletPublic = "wallet_public"
    static let fieldTypeMessage = "typeMessage"
    static let fieldTypeTitle = "typeTitle"
    static let fieldPatrimony = "patrimony"
    
    enum FieldsAboutFii: String, CaseIterable {
        case title_about_fii
        case what_are
        case management
        case quotas
        case public_distribution_offer
        case redemption_and_trading
        case investment_policy
        case distribution
        case risks
        case other_information
        
    }
    
    init(complete:@escaping(responseDone)) {
        ConfigureDataBase.checkConnectionToDatabase { response in
            UserDefaults.standard.set(response, forKey: ConfigureDataBase.fieldActiveDatabase)
            complete(response)
        }
    }
    
    static func checkConnectionToDatabase(complete:@escaping(responseDone)) {
        let ref = ConfigureDataBase.instance.collection(ConfigureDataBase.collectionParameters).document(ConfigureDataBase.documentMaintenance)
        ref.getDocument { document, error in
            if let document = document, document.exists {
                complete(document.data()?[fieldActiveDatabase] as? Bool ?? false)
            } else {
                complete(error?.localizedDescription.elementsEqual("Failed to get document because the client is offline.") ?? false ? true : false)
            }
            print(#function)
        }
    }
    
    static func dataa() {
        
    }
    
}
