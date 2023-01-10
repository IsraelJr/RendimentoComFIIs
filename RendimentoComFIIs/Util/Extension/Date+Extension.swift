//
//  Date+Extension.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 16/11/22.
//

import Foundation

extension Date {
    func convertToDatePtBr() -> String {
        let date = self.formatted(.dateTime.day().month(.twoDigits).year().locale(Locale(identifier: "pt_BR")))
        return date.count == 9 ? "0\(date)" : date
    }
}
