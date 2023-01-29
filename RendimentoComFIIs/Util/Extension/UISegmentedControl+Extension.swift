//
//  UISegmentedControl+Extension.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 12/12/22.
//

import UIKit

extension UISegmentedControl {
    func customizeAppearance(quantidadeItems: Int = 2) {
        self.selectedSegmentTintColor = UIColor(named: "Font")
        self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white
                                               , NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)
                                              ], for: .selected)
        self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        
        for i in 2..<quantidadeItems {
            self.insertSegment(withTitle: "", at: i, animated: true)
            
        }
        self.backgroundColor = .lightGray
        
    }
    
    func setTitleList(_ titleList: [String]) {
        for i in 0..<titleList.count {
            self.setTitle(NSLocalizedString(titleList[i], comment: ""), forSegmentAt: i)
            self.restorationIdentifier = titleList[i]
        }
    }
}
