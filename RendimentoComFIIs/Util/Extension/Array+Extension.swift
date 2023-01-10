//
//  Array+Extension.swift
//  RendimentoComFII
//
//  Created by Israel Alves on 10/05/22.
//

import UIKit

extension Array {
    func filterAccordingToUserDefinition() -> [FiisNews] {
        var list = self as! [FiisNews]
        var listSites = [String]()
        Sites.allCases.forEach({
            UserDefaults.standard.string(forKey: $0.rawValue) ?? "1" == "0" ? listSites.append($0.rawValue.uppercased()) : nil
        })
        list.removeAll(where: { item in
            item.siteName == listSites.first(where: { $0.elementsEqual(item.siteName) }) ? true : false
        })
        let totalPublications = UserDefaultKeys.totalNews.getValue() as! Int
        let max = (list.count >= totalPublications ? totalPublications : list.count)
        var result = [FiisNews]()
        for _ in 0..<max {
            result.append(list.remove(at: Int(arc4random_uniform(UInt32(list.count)))))
        }
        return result
    }
}
