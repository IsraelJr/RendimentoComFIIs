//
//  NavigationBarFooterViewController.swift
//  RendimentoComFII
//
//  Created by Israel Alves on 30/03/22.
//

import UIKit

protocol NavigationBarFooterDelegate {
    func didTapButtonNavigation(_ sender: UIButton)
}

class NavigationBarFooterView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet var collectionButton: [UIButton]!
    
    var delegate: NavigationBarFooterDelegate?
    
    let colorCustomized = UIColor.darkGray  //UIColor(named: "Border")
    let colorDefault = UIColor.lightGray
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("NavigationBarFooterView", owner: self, options: nil)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentView)
        setup()
    }
    
    private func setup() {
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 24
        contentView.backgroundColor = .clear
        viewBackground.backgroundColor = .black   //UIColor(named: "mainBlue")
        viewBackground.alpha = 0.3
        viewBackground.layer.cornerRadius = contentView.layer.cornerRadius
        
        let size: CGFloat = 40
        collectionButton.forEach({
            switch $0 {
            case collectionButton[0]:
                $0.setupDefault(size, "house")
                $0.tag = 0
                
            case collectionButton[1]:
                $0.setupDefault(size, "wallet.pass")
                $0.tag = 1
                
            case collectionButton[2]:
                $0.setupDefault(size, "magnifyingglass")
                $0.tag = 2
                
            case collectionButton[3]:
                $0.setupDefault(size, "square.grid.2x2")   //line.3.horizontal")
                $0.tag = 3
                
            default:
                break
            }
            $0.backgroundColor = .systemGray4
            $0.layer.borderWidth = 3
            $0.layer.borderColor = UIColor.white.cgColor
        })
    }
    
    @IBAction func didTapButton(_ sender: UIButton) {
        sender.pulseEffectInClick()
        delegate?.didTapButtonNavigation(sender)
    }
    
    func changeColorButton(_ position: Int!) {
        collectionButton.forEach({
            $0.tintColor = $0 == collectionButton[position] ? colorCustomized : colorDefault
//            collectionLabels[$0.tag].textColor = $0.tintColor
        })
    }
    
}


