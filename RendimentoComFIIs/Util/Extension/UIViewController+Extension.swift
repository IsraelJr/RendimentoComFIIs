//
//  UIViewController+Extension.swift
//  RendimentoComFII
//
//  Created by Israel Alves on 03/04/22.
//

import UIKit

extension UIViewController {
    func alertView(type: AlertType, message: String) -> AlertView {
        let vc = UIViewController()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        let alert = AlertView()
        alert.setupAlert(type: type, message: message)
        vc.view.addSubview(alert)
        present(vc, animated: true, completion: nil)
        return alert
    }
    
    func segueTo(destination: UIViewController) {
        self.view.superview?.insertSubview(destination.view, aboveSubview: self.view)
        destination.view.transform = CGAffineTransform(translationX: self.view.frame.size.width, y: 0)
        destination.modalPresentationStyle = .fullScreen
        
        UIView.animate(withDuration: 0.25,
                       delay: 0.0,
                       options: UIView.AnimationOptions.curveEaseInOut,
                       animations: {
            destination.view.transform = CGAffineTransform(translationX: 0, y: 0)
        },
                       completion: { finished in
            self.present(destination, animated: false, completion: nil)
        })
    }
    
    func dismissWith(_ type: CATransitionType? = .reveal) {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = type!
        transition.subtype = .fromLeft
        self.view.window!.layer.add(transition, forKey: kCATransition)
        
        dismiss(animated: false)
    }
}
