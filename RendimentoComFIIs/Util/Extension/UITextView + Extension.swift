//
//  UITextView + Extension.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 13/01/23.
//

import UIKit

extension UITextView {
    func setup(_ text: String = "") {
        self.text.removeAll()
        self.backgroundColor = .systemBackground
        self.enablesReturnKeyAutomatically = true
        self.keyboardType = .alphabet
        self.insertTextPlaceholder(with: CGSize(width: 100, height: 40))
        self.insertText(text)
        self.textColor = .placeholderText
        self.font = UIFont.boldSystemFont(ofSize: 16)
        self.tag = 0
        self.layer.cornerRadius = 16
        self.textAlignment = .natural
    }
}
