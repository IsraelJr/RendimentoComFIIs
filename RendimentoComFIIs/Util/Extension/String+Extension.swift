//
//  String+Extension.swift
//  RendimentoComFII
//
//  Created by Israel Alves on 01/04/22.
//

import UIKit

extension String {
    func dateTextWithYYYY() -> String {
        var textDate = ""
        var arrDate = [Substring]()
        var year = Substring()
        let arrDateHour = (self.isEmpty ? Util.currentDate() : self)
            .replacingOccurrences(of: "T", with: " ")
            .replacingOccurrences(of: " às ", with: " ")
            .replacingOccurrences(of: "-", with: "/")
            .replacingOccurrences(of: ".", with: "/")
            .split(separator: " ")
        if arrDateHour.count > 3 {
            arrDate = arrDateHour[4].split(separator: "/")
            year = arrDate[2].count == 2 ? "20\(arrDate[2])" : arrDate[2]
            textDate = " Atualizado em: \(arrDate[0])/\(arrDate[1])/\(year) \(arrDateHour[5])"
        }
        arrDate = arrDateHour[0].split(separator: "/")
        year = arrDate[2].count == 2 ? "20\(arrDate[2])" : arrDate[2]
        if arrDate[0].count == 4 {
            return "\(arrDate[2])/\(arrDate[1])/\(arrDate[0]) \(arrDateHour[1].prefix(5))"
        } else {
            return "\(arrDate[0])/\(arrDate[1])/\(year) \(arrDateHour[1])\(textDate)"
        }
    }
    
    func convertNumberphoneToNumber() -> Int {
        let character = ["(", ")", "-", ".", "/", "*", "#", " "]
        var number = self
        character.forEach({
            number = number.replacingOccurrences(of: $0, with: "").trimmingCharacters(in: .whitespacesAndNewlines)
        })
        return Int(number) ?? 0
    }
    
    func convertCurrencyToDouble() -> Double {
        let result = Double(self.replacingOccurrences(of: "R$", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: ",", with: ".").trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0.0
        return result
    }
    
    func addLineBreak() -> String {
        return self.replacingOccurrences(of: Util.umenter, with: "\n").replacingOccurrences(of: Util.doisenter, with: "\n\n")
    }
    
    func convertDateToInt() -> Int {
        let date = self.split(separator: "/")
        return date.count >= 3 ? Int("\(date[2].split(separator: .space)[0])\(date[1])\(date[0])") ?? 99999999 : 99999999
    }
    
    func isGreaterCurrentDate() -> Bool {
        let currentDate = Util.currentDate().split(separator: " ")[0].description
        return self.convertDateToInt() > currentDate.convertDateToInt() ? true : false
    }
    
    func openUrl() {
        UIApplication.shared.open(URL(string: self)!)
    }
    
    func firstLetterUppercased() -> String {
        return "\(self.prefix(1).capitalized)\(self.dropFirst())"
    }
    
    func toDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "pt_BR")
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC -3")
        return dateFormatter.date(from:self.prefix(10).trimmingCharacters(in: .whitespacesAndNewlines))!
    }
    
}
