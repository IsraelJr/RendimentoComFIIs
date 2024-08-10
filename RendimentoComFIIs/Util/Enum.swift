//
//  Enum.swift
//  RendimentoComFII
//
//  Created by Israel Alves on 11/04/22.
//

import Foundation
import UIKit

enum FiiSegment: String, CaseIterable {
    case mall = "Shoppings"
    case logistic = "Logística"
    case hybrid = "Híbrido"
    case corporate = "Lajes Corporativas"
    case residential = "Residencial"
    case hotel = "Hotel"
    case hospital = "Hospital"
    case agribusiness = "Agronegócio"
    case securities = "Títulos e Val. Mob."
    case educacional = "Educacional"
    case others = "Outros"
    case all = "Todos"
    
    func description() -> String {
        return self.rawValue
    }
    
    struct Category {
        var title: String
        var color: UIColor
        var image: UIImage
    }
    
    func category() -> Category {
        var category: Category!
        switch self {
        case .mall:
            category = Category(title: self.description(), color: .systemRed, image: UIImage(systemName: "cart.circle")!)
        case .logistic:
            category = Category(title: self.description(), color: .systemBlue, image: UIImage(systemName: "globe.americas.fill")!)
        case .hybrid:
            category = Category(title: self.description(), color: .systemGray, image: UIImage(systemName: "asterisk.circle")!)
        case .corporate:
            category = Category(title: self.description(), color: .systemGreen, image: UIImage(systemName: "building.2.crop.circle")!)
        case .residential:
            category = Category(title: self.description(), color: .systemYellow, image: UIImage(systemName: "house.circle")!)
        case .hotel:
            category = Category(title: self.description(), color: .systemPurple, image: UIImage(systemName: "building.columns.circle")!)
        case .hospital:
            category = Category(title: self.description(), color: .systemOrange, image: UIImage(systemName: "stethoscope.circle")!)
        case .agribusiness:
            category = Category(title: self.description(), color: .systemPink, image: UIImage(systemName: "sun.max.fill")!)
        case .securities:
            category = Category(title: self.description(), color: .systemBrown, image: UIImage(systemName: "dollarsign.circle")!)
        case .others:
            category = Category(title: self.description(), color: .lightGray, image: UIImage(systemName: "questionmark.circle")!)
        case .all:
            category = Category(title: self.description(), color: UIColor(named: "Font") ?? .gray, image: UIImage(systemName: "infinity.circle")!)
        case .educacional:
            category = Category(title: self.description(), color: .systemTeal, image: UIImage(systemName: "book.circle")!)
        }
        return category
    }
}

enum SocialNetwork: String, CaseIterable {
    case instagram = "Instagram"
    case facebook = "Facebook"
    case whatsapp = "Whatsapp"
    case telegram = "Telegram"
    case twitter = "Twitter"
    case linkedin = "Linkedin"
}

enum Month: Int, CaseIterable {
    case january = 1
    case february = 2
    case march = 3
    case april = 4
    case may = 5
    case june = 6
    case july = 7
    case august = 8
    case september = 9
    case october = 10
    case november = 11
    case december = 12
    case current = 0
    
    
    func description() -> (String, String) {
        switch self {
        case .january:
            return(NSLocalizedString("1", comment: ""), NSLocalizedString("12", comment: ""))
            
        case .february:
            return(NSLocalizedString("2", comment: ""), NSLocalizedString("1", comment: ""))
            
        case .march:
            return(NSLocalizedString("3", comment: ""), NSLocalizedString("2", comment: ""))
            
        case .april:
            return(NSLocalizedString("4", comment: ""), NSLocalizedString("3", comment: ""))
            
        case .may:
            return(NSLocalizedString("5", comment: ""), NSLocalizedString("4", comment: ""))
            
        case .june:
            return(NSLocalizedString("6", comment: ""), NSLocalizedString("5", comment: ""))
            
        case .july:
            return(NSLocalizedString("7", comment: ""), NSLocalizedString("6", comment: ""))
            
        case .august:
            return(NSLocalizedString("8", comment: ""), NSLocalizedString("7", comment: ""))
            
        case .september:
            return(NSLocalizedString("9", comment: ""), NSLocalizedString("8", comment: ""))
            
        case .october:
            return(NSLocalizedString("10", comment: ""), NSLocalizedString("9", comment: ""))
            
        case .november:
            return(NSLocalizedString("11", comment: ""), NSLocalizedString("10", comment: ""))
            
        case .december:
            return(NSLocalizedString("12", comment: ""), NSLocalizedString("11", comment: ""))
            
        case .current:
            return(Month(rawValue: Calendar.current.component(.month, from: Date())))!.description()
            
        }
    }
}

enum CRUD: String {
    case create
    case read
    case readFuture
    case updtate
    case delete
    case deleteFuture
}


enum MoreOptions: String, CaseIterable {
    case aboutfii
    case aboutapp
    case library
    case archive
    case contactus
    case male
    case female
    case neutral
    case settings
    case exit
    
    func description() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}

enum TypeAnimateTransition {
    case dragFromRightToLeft
    case zoom
    case alpha
    case wave
    case LeftToRight
    case rightToLeft
    case TopToBottom
    case bounce
    case rotate
    case linear
    case spacialAnimationCardDrop
}

enum UserDefaultKeys: String {
    case userCreatedIn
    case hideNewsAlert
    case firstAccessDay
    case downloadNews
    case changeNews
    case basicSalary
    case totalNews
    case totalNewsInArchive
    case fiis
    case suno
    case valorinveste
    case euqueroinvestir
    case accept_terms
    case vip
    case sentMessage
    case wallet_public_isVisible
    case wallet_public_has
    case unread_message
    case lifetime
    
    func setValue(value: Any) {
        switch self {
        case .totalNewsInArchive, .userCreatedIn, .accept_terms, .vip, .wallet_public_isVisible, .unread_message, .lifetime, .wallet_public_has:
            let key = (self == .lifetime || self == .vip) ? "\(DataUser.email!)\(self.rawValue)" : self.rawValue
            UserDefaults.standard.set(value, forKey: key)
            self == .lifetime && value as! Bool == true ? UserDefaultKeys.vip.setValue(value: true) : nil
            
        case .basicSalary:
            if let salary = (value as! [String:Int]).first(where: { $0.key.elementsEqual(Util.currentYear) }) {
                UserDefaults.standard.setPersistentDomain([salary.key:salary.value], forName: "\(self.rawValue):\(salary.key)")
            } else {
                UserDefaults.standard.setPersistentDomain([Util.currentYear:0], forName: "\(self.rawValue):\(Util.currentYear)")
            }
            
        case .fiis:
            UserDefaults.standard.set((value as? String)?.trimmingCharacters(in: .whitespacesAndNewlines), forKey: Sites.fiis.rawValue.trimmingCharacters(in: .whitespacesAndNewlines))
            
        case .sentMessage:
            var newId: Int = 0
            var listIds = [Int]()
            if let listTemp = UserDefaultKeys.sentMessage.getValue() as? [String] {
                listTemp.forEach({
                    !$0.isEmpty ? listIds.append(Int($0.split(separator: ";").first!.replacingOccurrences(of: "sm:", with: ""))!) : nil
                })
                for i in 0..<1000 {
                    if !listIds.contains(i) {
                        newId = i
                        break
                    }
                }
            }
            let model = (value as! ContactUsModel.Fetch.ContactUs)
            let msg = "sm:\(newId);\(model.typeTitle.rawValue.firstLetterUppercased());\(model.message!);\(Util.currentDate().prefix(10));\(model.id!)"
            UserDefaults.standard.set(msg, forKey: msg.split(separator: ";").first!.description)
            
        default:
            break
        }
    }
    
    func getValue() -> Any {
        var result: Any?
        switch self {
        case .userCreatedIn:
            result = UserDefaults.standard.string(forKey: self.rawValue)
            
        case .basicSalary:
            if let salary = UserDefaults.standard.persistentDomain(forName: "\(self.rawValue):\(Util.currentYear)") {
                result = salary
            } else {
                result = [Util.currentYear:0]
            }
            
        case .totalNews, .totalNewsInArchive:
            let value = UserDefaults.standard.integer(forKey: self.rawValue)
            result = value == 0 ? (self == .totalNews ? 10 : 20) : value
            
        case .fiis, .suno, .euqueroinvestir, .valorinveste, .accept_terms:
            result = UserDefaults.standard.bool(forKey: self.rawValue)
            
        case .vip, .wallet_public_isVisible, .unread_message, .lifetime, .wallet_public_has:
            let key = (self == .lifetime || self == .vip) ? "\(DataUser.email!)\(self.rawValue)" : self.rawValue
            result = UserDefaults.standard.bool(forKey: key)
            
        case .sentMessage:
            var list = [""]
            for i in 0..<1000 {
                if let msg = UserDefaults.standard.string(forKey:"sm:\(i)") {
                    list.append(msg)
                }
            }
            result = list
            
        default:
            result = UserDefaults.standard.string(forKey: self.rawValue) ?? ""
        }
        return result!
    }
}

enum WalletRating: String, CaseIterable {
    case conservative
    case moderate
    case aggressive
    
    func description() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
    
    func getColor() -> CGColor {
        switch self {
        case .conservative:
            return UIColor.systemGreen.cgColor
            
        case .moderate:
            return UIColor.systemYellow.cgColor
            
        case .aggressive:
            return UIColor.systemRed.cgColor
        }
    }
}
