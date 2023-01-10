//
//  UIButton+Extension.swift
//  RendimentoComFII
//
//  Created by Israel Alves on 23/04/22.
//

import UIKit

extension UILabel {
    func startMarqueeLabelAnimation(listLabels: [UILabel]) {
        DispatchQueue.main.async(execute: {
            UIView.animate(withDuration: 10.0, delay: 0, options: ([.curveLinear, .repeat]), animations: {() -> Void in
                listLabels.forEach({
                    $0.center = CGPoint(x: 0 - $0.bounds.size.width / 2, y: $0.center.y)
                })
            }, completion:  nil)
        })
    }
    
}
