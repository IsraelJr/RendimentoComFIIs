//
//  UIImage+Extension.swift
//  RendimentoComFII
//
//  Created by Israel Alves on 11/04/22.
//

import UIKit

extension UIImageView {
    func addText(_ text: String, _ color: UIColor? = UIColor(named: "mainBlue")!) {
        self.subviews.forEach({ $0.removeFromSuperview() })
        let initials = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height))
        initials.center = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
        initials.textAlignment = .center
        initials.text = text
        initials.font = UIFont.boldSystemFont(ofSize: 20)
        initials.textColor = .white
        initials.backgroundColor = color
        self.layer.cornerRadius = 16
        self.addSubview(initials)
    }
}


