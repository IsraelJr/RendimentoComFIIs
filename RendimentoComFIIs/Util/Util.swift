//
//  Functions.swift
//  RendimentoComFII
//
//  Created by Israel Alves on 04/04/22.
//

import Foundation
import FirebaseAuth
import GoogleSignIn
import UIKit

typealias responseDone = (_ response: Bool) ->()
typealias responseHandlerArrayOfArrayOfTuple = (_ response: [[(String,String)]]) ->()
typealias responseHandlerArrayOfTuple = (_ response: [(Any,Any)]) ->()
typealias responseHandlerArray = (_ response: [Any]) ->()
typealias responseHandlerMap = (_ response: [String:Any]?) ->()

class Util {
    static var locale = Locale.current.languageCode?.elementsEqual("pt") ?? true ? "localePtBr" : "otherLocale"
    static var doisenter = "[doisenter]"
    static var umenter = "[umenter]"
    static let currentYear = Calendar.current.component(.year, from: Date()).description
    
    struct DataToSimulator {
        var targetValue: Double!
        var priceCurrent: Double!
        var currentMonthEarnings: Double!
        var valueWithSymbol: Bool? = false
    }
    
    static func currentDate() -> String {
        let calendar = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: Date())
        let arrayDateInt = [calendar.day, calendar.month, calendar.year, calendar.hour, calendar.minute]
        var arrayDateString = [String]()
        arrayDateInt.forEach({
            arrayDateString.append(String($0!).count == 1 ? "0\($0!)" : "\($0!)")
        })
        return "\(arrayDateString[0])/\(arrayDateString[1])/\(arrayDateString[2]) \(arrayDateString[3]):\(arrayDateString[4])"
    }
    
    static func formatNumberPhone(phone: String!) -> String {
        if phone.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return " "
        }
        var number = String(phone.convertNumberphoneToNumber())
        
        if Int(number) ?? 0 > 0 {
            number.insert("(", at: number.index(number.startIndex, offsetBy: 0))
            number.insert(")", at: number.index(number.startIndex, offsetBy: 3))
            number.insert(" ", at: number.index(number.startIndex, offsetBy: 4))
            number.insert("-", at: number.index(number.startIndex, offsetBy: 9))
        } else {
            return " "
        }
        return number
    }
    
    static func calculationToReceiveEarnings(to: DataToSimulator) -> (totalQuotas: Int, estimatedValue: String) {
        let x = to.targetValue / (to.currentMonthEarnings == 0 ? 1 : to.currentMonthEarnings)
        let quotas = Int(x.rounded(.awayFromZero))
        let value = to.priceCurrent * Double(quotas)
        return (quotas, value.convertToCurrency(to.valueWithSymbol!))
    }
    
    static func userDefaultForWallet(action: CRUD, code: String!, quotas: String? = "0") -> (code: String, quotas: Int64, month: Int8) {
        var result = (code: "", quotas: Int64(0), month: Int8())
        let codeUpper = code.uppercased()
        let user = DataUser.email ?? ""
        switch action {
        case .create:
            UserDefaults.standard.set(codeUpper, forKey: "\(user)\(NSLocalizedString("inthewallet", comment: "").replacingOccurrences(of: "code", with: codeUpper))")
            UserDefaults.standard.set(Int64(quotas ?? "0"), forKey: "\(user)\(NSLocalizedString("totalquotas", comment: "").replacingOccurrences(of: "code", with: codeUpper))")
            
        case .delete:
            UserDefaults.standard.removeObject(forKey: "\(user)\(NSLocalizedString("inthewallet", comment: "").replacingOccurrences(of: "code", with: codeUpper))")
            UserDefaults.standard.removeObject(forKey: "\(user)\(NSLocalizedString("totalquotas", comment: "").replacingOccurrences(of: "code", with: codeUpper))")
            
        case .deleteFuture:
            UserDefaults.standard.removeObject(forKey: "\(user)\(NSLocalizedString("futureinthewallet", comment: "").replacingOccurrences(of: "code", with: codeUpper))")
            UserDefaults.standard.removeObject(forKey: "\(user)\(NSLocalizedString("futuretotalquotas", comment: "").replacingOccurrences(of: "code", with: codeUpper))")
            UserDefaults.standard.removeObject(forKey: "\(user)\(NSLocalizedString("futuredatequotas", comment: "").replacingOccurrences(of: "code", with: codeUpper))")
            
        case .read:
            result.code = UserDefaults.standard.string(forKey: "\(user)\(NSLocalizedString("inthewallet", comment: "").replacingOccurrences(of: "code", with: codeUpper))") ?? ""
            result.quotas = Int64(UserDefaults.standard.integer(forKey: "\(user)\(NSLocalizedString("totalquotas", comment: "").replacingOccurrences(of: "code", with: codeUpper))"))
            
        case .readFuture:
            result.code = UserDefaults.standard.string(forKey: "\(user)\(NSLocalizedString("futureinthewallet", comment: "").replacingOccurrences(of: "code", with: codeUpper))") ?? ""
            result.quotas = Int64(UserDefaults.standard.integer(forKey: "\(user)\(NSLocalizedString("futuretotalquotas", comment: "").replacingOccurrences(of: "code", with: codeUpper))"))
            result.month = Int8(UserDefaults.standard.integer(forKey: "\(user)\(NSLocalizedString("futuredatequotas", comment: "").replacingOccurrences(of: "code", with: codeUpper))"))
            
        case .updtate:
            UserDefaults.standard.set(codeUpper, forKey: "\(user)\(NSLocalizedString("futureinthewallet", comment: "").replacingOccurrences(of: "code", with: codeUpper))")
            UserDefaults.standard.set(Int64(quotas ?? "0"), forKey: "\(user)\(NSLocalizedString("futuretotalquotas", comment: "").replacingOccurrences(of: "code", with: codeUpper))")
            let monthCurrent = Calendar.current.component(.month, from: Date())
            UserDefaults.standard.set(monthCurrent == 12 ? 1 : monthCurrent + 1, forKey: "\(user)\(NSLocalizedString("futuredatequotas", comment: "").replacingOccurrences(of: "code", with: codeUpper))")
        }
        return result
    }
    
    static func userDefaultForMonth(action: CRUD, _ month: String? = "", _ earnings: Double? = 0.0) -> (month: String, earnings: Double) {
        var result = (month: month!, earnings: earnings!)
        let user = DataUser.email ?? ""
        switch action {
        case .create:
            UserDefaults.standard.set(result.earnings, forKey: "\(user)\(NSLocalizedString(result.month, comment: ""))")
            
        case .delete:
            Month.allCases.forEach({
                UserDefaults.standard.removeObject(forKey: "\(user)\($0.description().0)")
                UserDefaults.standard.removeObject(forKey: "\(user)\(NSLocalizedString($0.description().0, comment: ""))")
            })
            
        case .deleteFuture:
            break
            
        case .read:
            result = (NSLocalizedString(result.month, comment: ""), UserDefaults.standard.double(forKey: "\(user)\(NSLocalizedString(result.month, comment: ""))"))
            
        case .readFuture:
            break
            
        case .updtate:
            break
        }
        return result
    }
    
    static func exit() {
        ConfigureDataBase.instance.terminate()
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        GIDSignIn.sharedInstance.signOut()
        do {
            try Auth.auth().signOut()
        } catch {
            print(error.localizedDescription)
        }
        Darwin.exit(0)
    }
    
    static func hideAlertMessage() {
        UserDefaults.standard.set(true, forKey: UserDefaultKeys.hideNewsAlert.rawValue)
    }
    
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    static func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
    
    static func compareDateIsEqualDateCurrent(dateString: String) -> Bool {
        return Util.currentDate().prefix(10).elementsEqual(dateString) ? true : false
    }
    
    static func calculatePortfolioRatioByFii() -> [(String,String)] {
        var listFiis = [(String,String)]()
        WalletViewController.wallet?.wallet?.forEach({ item in
            (!item.values.isEmpty && item.values.first != 0) ? listFiis.append((item.keys.first!, item.values.first!.description)) : nil
        })
        var total: Double = 0
        var peso = [Double]()
        listFiis.forEach({ total += Double($0.1)! })
        listFiis.forEach({ peso.append(Double($0.1)!/total)})
        
        let numberFormatter = NumberFormatter().percentWith2Decimal()
        
        var result = [(String,String)]()
        for i in 0..<peso.count {
            result.append((listFiis[i].0, numberFormatter.string(from: NSNumber(value: peso[i]))!))
        }
        return result.sorted(by: {Double($0.1.description.replacingOccurrences(of: ",", with: "").replacingOccurrences(of: "%", with: "")) ?? 0 > Double($1.1.description.replacingOccurrences(of: ",", with: "").replacingOccurrences(of: "%", with: "")) ?? 0})
    }
    
    static func calculatePortfolioRatioBySegment() -> [(String,String)] {
        var listFiis = [String]()
        WalletViewController.wallet?.wallet?.forEach({ item in
            (!item.values.isEmpty && item.values.first != 0) ? listFiis.append(item.keys.first!) : nil
        })
        
        var listSegments = [FiiSegment]()
        listFiis.forEach { fii in
            if var segment = ListFii.listFiis.first(where: { $0.code.elementsEqual(fii) } )?.segment {
                segment = segment.elementsEqual("Recebíveis Imobiliários") ? FiiSegment.securities.rawValue : segment
                listSegments.append(FiiSegment(rawValue: segment)!)
            }
        }
        
        var listTemp = [(FiiSegment,Double)]()
        listSegments.forEach { segment in
            let total = (listTemp.first(where: { $0.0 == segment } )?.1 ?? 0) + 1
            listTemp.removeAll(where: {$0.0 == segment})
            listTemp.append((segment, total))
        }
        
        let numberFormatter = NumberFormatter().percentWith2Decimal()
        
        return listTemp.map( { ($0.0.rawValue, numberFormatter.string(from: NSNumber(value: $0.1 / Double(listSegments.count)))!) } ).sorted(by: { $0.1 > $1.1 } )
    }
    
}
