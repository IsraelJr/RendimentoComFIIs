//
//  UISegmentedControl+Extension.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 12/12/22.
//

import UIKit

extension UISegmentedControl {
    func customizeAppearance() { 
        self.selectedSegmentTintColor = UIColor(named: "Font")
        self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white
                                               , NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)
                                              ], for: .selected)
        self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        self.backgroundColor = .lightGray
        
    }
    
    func setTitleList(_ titleList: [String]) {
        for i in 0..<titleList.count {
            self.setTitle(NSLocalizedString(titleList[i], comment: ""), forSegmentAt: i)
        }
    }
}
