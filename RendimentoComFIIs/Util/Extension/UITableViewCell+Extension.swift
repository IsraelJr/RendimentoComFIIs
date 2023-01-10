//
//  UITableViewCell+Extension.swift
//  RendimentoComFII
//
//  Created by Israel Alves on 28/04/22.
//

import UIKit

extension UITableViewCell {
    func animateTransition(_ index: Int, _ type: TypeAnimateTransition? = .rightToLeft) {
        switch type {
        case .dragFromRightToLeft:
            self.center.x += 200
            UIView.animate(withDuration: 0.5, delay: 0.05 * Double(index), animations: { self.center.x -= 200 })
            
        case .zoom:
            self.transform = CGAffineTransform(scaleX: 0, y : 0)
            UIView.animate(withDuration: 0.5, animations: { self.transform = CGAffineTransform(scaleX: 1, y : 1) })
            
        case .alpha:
            self.alpha = 0
            UIView.animate(withDuration: 1.5, delay: 0.05 * Double(index), animations: { self.alpha = 1 })
            
        case .wave:
            self.transform = CGAffineTransform(translationX: self.contentView.frame.width, y: 0)
            UIView.animate(withDuration: 2.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.4, initialSpringVelocity: 0.1,
             options: .curveEaseIn, animations: {
             self.transform = CGAffineTransform(translationX: self.contentView.frame.width, y: self.contentView.frame.height)
             })
        
        case .LeftToRight:
            self.transform = CGAffineTransform(translationX: 0, y: self.contentView.frame.height)
             UIView.animate(withDuration: 0.5, delay: 0.05 * Double(index), animations: {
             self.transform = CGAffineTransform(translationX: self.contentView.frame.width, y: self.contentView.frame.height)
             })
            
        case .rightToLeft:
            self.transform = CGAffineTransform(translationX: self.contentView.frame.width, y: 0)
             UIView.animate(
             withDuration: 0.5,
             delay: 0.05 * Double(index),
             options: [.curveEaseInOut],
             animations: {
             self.transform = CGAffineTransform(translationX: 0, y: 0)
             })
            
        case .TopToBottom:
            self.transform = CGAffineTransform(translationX: self.contentView.frame.width, y: 0)
             UIView.animate(withDuration: 0.5, delay: 0.05 * Double(index), animations: {
             self.transform = CGAffineTransform(translationX: self.contentView.frame.width, y: self.contentView.frame.height)
             })
            
        case .bounce:
            self.transform = CGAffineTransform(translationX: self.contentView.frame.width, y: 0)
            UIView.animate(withDuration: 1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.4, initialSpringVelocity: 0.1,
             options: .curveEaseIn, animations: {
             self.transform = CGAffineTransform(translationX: self.contentView.frame.width, y: self.contentView.frame.height)
             })
        
        case .rotate:
            self.transform = CGAffineTransform(rotationAngle: 360)
             UIView.animate(withDuration: 0.5, delay: 0.05 * Double(index), animations: {
             self.transform = CGAffineTransform(rotationAngle: 0.0)
             })
            
        case .linear:
            self.transform = CGAffineTransform(translationX: self.contentView.frame.width, y: self.contentView.frame.height)
             UIView.animate(
             withDuration: 0.5,
             delay: 0.05 * Double(index),
             options: [.curveLinear],
             animations: {
             self.transform = CGAffineTransform(translationX: 0, y: 0)
             })
            
        case .spacialAnimationCardDrop:
            let TipInCellAnimatorStartTransform: CATransform3D = {
                    let rotationDegrees: CGFloat = -15.0
                    let rotationRadians: CGFloat = rotationDegrees * (CGFloat(Double.pi)/180.0)
                    let offset = CGPoint(x: -20, y: -20)
                    var startTransform = CATransform3DIdentity
                    startTransform = CATransform3DRotate(CATransform3DIdentity,
                                                         rotationRadians, 0.0, 0.0, 1.0)
                    startTransform = CATransform3DTranslate(startTransform, offset.x, offset.y, 0.0)
                    
                    return startTransform
                }()
            let view = self.contentView
             view.layer.transform = TipInCellAnimatorStartTransform
             view.layer.opacity = 0.8
             UIView.animate(withDuration: 0.5) {
             view.layer.transform = CATransform3DIdentity
             view.layer.opacity = 1
             }
        
        default:
            break
        }
        
    }
}
