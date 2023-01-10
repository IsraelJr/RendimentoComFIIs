//
//  WalletHistoricWorker.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import Foundation
import UIKit

class WalletHistoricWorker {
    
    func saveMonthlyEarnings(updateDate: (month: String, year: String), complete:@escaping(responseHandlerArrayOfTuple)) {
        let ref = ConfigureDataBase.instance.collection(ConfigureDataBase.collectionUser).document(DataUser.email ?? "")
        ref.getDocument { document, error in
            if error == nil {
                if let document = document, document.exists {
                    let value = Util.userDefaultForMonth(action: .read, updateDate.month)
                    if let earnings = (document.data()!["earnings"] as! [String:Any]?)?.first(where: { $0.key.elementsEqual(updateDate.year) })?.value as? [String:Double] {
                        if let _ = earnings.first(where: { $0.key.elementsEqual(value.month) }) {
                            complete([(false,NSLocalizedString("failure_month1", comment: "").replacingOccurrences(of: "[month]", with: NSLocalizedString(value.month, comment: "")))])
                        } else {
                            ref.setData([
                                "earnings":[updateDate.year:[
                                    value.month : value.earnings
                                ]]], merge: true)
                            complete([(true,NSLocalizedString("success_month1", comment: "").replacingOccurrences(of: "[month]", with: NSLocalizedString(value.month, comment: "")))])
                        }
                    } else {
                        if updateDate.year.elementsEqual((Int(Util.currentYear)!-1).description) {
                            ref.setData([
                                "earnings":[updateDate.year:[
                                    value.month : value.earnings
                                ]]], merge: true)
                            complete([(true,NSLocalizedString("success_month1", comment: "").replacingOccurrences(of: "[month]", with: NSLocalizedString(value.month, comment: "")))])
                        } else {
                            complete([(false,"")])
                        }
                    }
                    _ = Util.userDefaultForMonth(action: .delete)
                } else {
                    complete([(false,"")])
                }
            } else {
                complete([(false,"")])
            }
        }
    }
    
    func delete() {
        _ = Util.userDefaultForMonth(action: .delete)
    }
}
