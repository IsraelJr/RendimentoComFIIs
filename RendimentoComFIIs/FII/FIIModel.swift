//
//  FIIModel.swift
//  Pods
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

var quoteList = [FIIQuotationSheet]()

struct FIIModel: Decodable {
    struct Fetch {
        struct Request {
            var object: FII!
        }
        struct Response {
            var object: FII?
            var isError: Bool!
            var message: String?
        }
        struct FII {
            var socialReason: String!
            var name: String!
            var code: String!
            var segment: String?
            var price: String?
            var earnings: [String:[String:Any]]?
            var dailyLiquidity: String?
            var dividendYield: String?
            var netWorth: String?
            var equityValue: String?
            var numberShares: Int?
            var profitabilityMonth: String?
            var phone: String?
            var site: String?
            var social_network: ([String:String])?
            var equityValuePerShare: Double?
            var pvp: Double?
            var hrefReport: String?
            var isIFIX: Bool?
        }
    }
}

struct FIIQuotationSheet {
    var code: String
    var currentPrice: String
    var opening: String
    var variation: String
    var minimum: String
    var maximum: String
    var closingPrevious: String
    var numberShares: Int
}

extension FIIModel.Fetch.FII {
    mutating func calcEquityValuePerShare() {
        let x = Double(self.equityValue?.replacingOccurrences(of: "R$ ", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: ",", with: "") ?? "0.0") ?? 0.0
        self.equityValuePerShare = x / Double(self.numberShares ?? 0)
    }
    
    mutating func calcPVP() {
        let x = Double(self.price?.replacingOccurrences(of: "R$ ", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: ",", with: ".") ?? "0.0") ?? 0.0
        self.pvp = x / Double(self.equityValuePerShare ?? 0.0)
    }
    
    func calcAgio(atual: Double, patrimo: Double) -> Double {
        return (atual - patrimo) / patrimo * 100
    }
    
    func getIncome(earnings: String?, price: String?) -> String {
        let priceDateWith = price?.convertCurrencyToDouble() ?? 0.0
        let base = (earnings?.convertCurrencyToDouble()) ?? 0.0
        return "\((base/priceDateWith)*100)"
    }
}
