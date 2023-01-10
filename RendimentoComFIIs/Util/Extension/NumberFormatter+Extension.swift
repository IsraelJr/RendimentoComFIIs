//
//  NumberFormatter+Extension.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 14/12/22.
//

import UIKit

extension NumberFormatter {
    func percentWith2Decimal() -> NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .percent
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        return numberFormatter
    }
}
