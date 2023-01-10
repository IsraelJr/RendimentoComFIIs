//
//  UIButton+Extension.swift
//  RendimentoComFII
//
//  Created by Israel Alves on 30/03/22.
//

import UIKit

extension UIButton {
    func setupDefault(_ size: CGFloat!, _ nameImg: String? = nil, _ title: String? = "") {
        self.frame = CGRect(x: 0, y: 0, width: size, height: size)
        self.setTitle(title, for: .normal)
        self.backgroundColor = .clear
        self.tintColor = .label
        self.layer.cornerRadius = self.frame.width / 2
        self.setImage(UIImage(systemName: nameImg ?? "arrow.backward"), for: .normal)
    }
    
    func pulseEffectInClick(colorEffect: UIColor? = .lightGray) {
        let colorAnimation = CABasicAnimation(keyPath: "backgroundColor")
        colorAnimation.fromValue = self.tintColor?.cgColor
        colorAnimation.duration = 0.5
        self.layer.add(colorAnimation, forKey: "ColorPulse")
    }

    func didTapAddToWallet(codeFii: String, action: CRUD) {
        let nameImg = action == .create ? "star.fill" : "star"
        let title = action == .create ? "Retirar da Carteira  " : "Adicionar à Carteira  "
        self.tintColor = action == .create ? UIColor(named: AlertType.warning.rawValue) : UIColor(named: AlertType.info.rawValue)
        self.pulseEffectInClick(colorEffect: action == .create ? .systemYellow : .black)
        _ = Util.userDefaultForWallet(action: action, code: codeFii)
        self.setImage(UIImage(systemName: nameImg), for: .normal)
        self.setTitle(title, for: .normal)
        self.layer.shadowColor = self.tintColor.cgColor
    }
    
//    func didTapEdit(_ field: UITextField!) {
//        if field.text?.count ?? 0 > 0 {
//            field.isEnabled = !field.isEnabled
//            field.becomeFirstResponder()
//            self.pulseEffectInClick()
//            self.isEnabled = !field.isEnabled
//        } else {
//            self.isEnabled = false
//            field.isEnabled = !self.isEnabled
//        }
//        field.textColor = field.isEnabled ? .black : .lightGray
//
//    }
}
