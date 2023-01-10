//
//  UIView+Extension.swift
//  RendimentoComFII
//
//  Created by Israel Alves on 30/03/22.
//

import UIKit

extension UIView {
    func createNavigationBarFooter(position: Int!) -> NavigationBarFooterView {
        let viewNBF = NavigationBarFooterView()
        viewNBF.backgroundColor = .clear
        viewNBF.changeColorButton(position)
        viewNBF.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(viewNBF)
        NSLayoutConstraint.activate([
            viewNBF.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16)
            ,viewNBF.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20)
            ,viewNBF.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16)
            ,viewNBF.heightAnchor.constraint(equalToConstant: 64)
        ])
        
        return viewNBF
    }
    
    func loading() -> UIView {
        let viewMain = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        self.addSubview(viewMain)
        
        let viewBackground = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        viewBackground.backgroundColor = .black
        viewBackground.alpha = 0.2
        viewMain.addSubview(viewBackground)
        viewBackground.translatesAutoresizingMaskIntoConstraints = false
        
        let viewLoadingBar = GradientHorizontalProgressBar()
        viewLoadingBar.color = UIColor(named: "Border") ?? .lightGray
        viewLoadingBar.progress = 1
        viewLoadingBar.gradientColor = .white//color == .X ? .darkGray : .white
        viewMain.addSubview(viewLoadingBar)
        viewLoadingBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            viewMain.topAnchor.constraint(equalTo: self.topAnchor, constant: 0)
            ,viewMain.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0)
            ,viewMain.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0)
            ,viewMain.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
            
            ,viewBackground.topAnchor.constraint(equalTo: viewMain.topAnchor, constant: 0)
            ,viewBackground.leadingAnchor.constraint(equalTo: viewMain.leadingAnchor, constant: 0)
            ,viewBackground.trailingAnchor.constraint(equalTo: viewMain.trailingAnchor, constant: 0)
            ,viewBackground.bottomAnchor.constraint(equalTo: viewMain.bottomAnchor, constant: 0)
            
            ,viewLoadingBar.centerXAnchor.constraint(equalTo: viewBackground.centerXAnchor, constant: 0)
            ,viewLoadingBar.centerYAnchor.constraint(equalTo: viewBackground.centerYAnchor, constant: 0)
        ])
        
       return viewMain
    }
    
    func closeKeyboard() {
        self.endEditing(true)
        self.resignFirstResponder()
    }
}
