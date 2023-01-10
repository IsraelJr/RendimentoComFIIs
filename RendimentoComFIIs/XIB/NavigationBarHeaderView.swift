//
//  NavigationBarviewHeader.swift
//  RendimentoComFII
//
//  Created by Israel Alves on 31/03/22.
//

import UIKit

protocol NavigationBarHeaderDelegate {
    func didTapButtonBack(_ sender: UIButton)
}

class NavigationBarHeaderView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var btnReturn: UIButton!
    @IBOutlet weak var lbTitle: UILabel!
    
    var delegate: NavigationBarHeaderDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit() {
        Bundle.main.loadNibNamed("NavigationBarHeaderView", owner: self, options: nil)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentView)
        setup()
    }
    
    private func setup() {
        contentView.backgroundColor = .clear
        viewBackground.backgroundColor = UIColor(named: "Font")
        btnReturn.setupDefault(30)
        btnReturn.tintColor = .white
        lbTitle.font = UIFont.boldSystemFont(ofSize: 28)
        lbTitle.textAlignment = .center
        lbTitle.numberOfLines = 1
        lbTitle.adjustsFontSizeToFitWidth = true
        lbTitle.minimumScaleFactor = 0.1
        lbTitle.textColor = btnReturn.tintColor
    }
    
    func setTitleHeader(name: String) {
        lbTitle.text = name
    }
    
    @IBAction func didTapButtons(_ sender: UIButton) {
        delegate?.didTapButtonBack(sender)
    }
    
}
