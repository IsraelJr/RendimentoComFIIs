//
//  UIColor+Extension.swift
//  RendimentoComFII
//
//  Created by Israel Alves on 13/04/22.
//

import UIKit

extension UIColor {
    var colorRadioActive: UIColor {
        get {
            return .systemGreen
        }
    }
    
    var colorRadioDisabled: UIColor {
        get {
            return .lightGray
        }
    }
    
    class func variationColor(to value: String?, inverse: Bool? = false) -> UIColor {
        let percent = Double(value?
                                .replacingOccurrences(of: " Variação (dia)", with: "")
                                .replacingOccurrences(of: "R$", with: "")
                                .replacingOccurrences(of: " ", with: "")
                                .replacingOccurrences(of: "%", with: "")
                                .replacingOccurrences(of: ",", with: ".")
                                .replacingOccurrences(of: "+", with: "") ?? "0.0") ?? 0.0
        if percent > 0.0 {
            return inverse! ? .systemRed : .systemGreen
        } else if percent < 0.0 {
            return inverse! ? .systemGreen : .systemRed
        }
        return .gray
    }
    
    
}
