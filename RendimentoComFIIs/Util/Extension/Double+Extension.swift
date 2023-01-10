//
//  String+Extension.swift
//  RendimentoComFII
//
//  Created by Israel Alves on 01/04/22.
//

import UIKit

extension Double {
    func convertToCurrency(_ withSymbol: Bool = false) -> String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale(identifier: "pt_BR")
        let result = withSymbol ? (currencyFormatter.string(from: NSNumber(value: self)) ?? "R$ 0,0") : (currencyFormatter.string(from: NSNumber(value: self))?.replacingOccurrences(of: "R$", with: "") ?? "0,0")
        return result.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
}
