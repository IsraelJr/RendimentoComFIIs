//
//  AlertViewController.swift
//  RendimentoComFII
//
//  Created by Israel Alves on 03/04/22.
//

import UIKit

@objc protocol ActionButtonAlertDelegate {
    func close()
    @objc optional func yes()
}

enum AlertType: String {
    case info
    case warning
    case success
    case error
    
    func description() -> String {
        return NSLocalizedString(self.rawValue, comment: "").uppercased()
    }
}

class AlertView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var viewAlert: UIView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var close: UIButton!
    @IBOutlet weak var yes: UIButton!
    
    var delegate: ActionButtonAlertDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("AlertView", owner: self, options: nil)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentView)
        setup()
    }
    
    private func setup() {
        contentView.backgroundColor = .clear
        viewAlert.layer.cornerRadius = 16
        image.backgroundColor = .white
        image.layer.cornerRadius = image.frame.width/2
        title.font = UIFont.boldSystemFont(ofSize: 16)
        title.textColor = image.backgroundColor
        title.textAlignment = .center
        message.textColor = image.backgroundColor
        message.adjustsFontSizeToFitWidth = true
        message.numberOfLines = 10
        message.minimumScaleFactor = 0.1
        close.setTitle(NSLocalizedString("close", comment: ""), for: .normal)
        close.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        close.backgroundColor = .clear
        
        yes.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        yes.isHidden = true
        yes.layer.cornerRadius = 8
    }
    
    func setupAlert(type: AlertType!, message: String!) {
        switch type {
        case .error:
            image.image = UIImage(systemName: "multiply.circle")
            
        case.info:
            image.image = UIImage(systemName: "info.circle")
            
        case.success:
            image.image = UIImage(systemName: "checkmark.circle")
            
        case.warning:
            image.image = UIImage(systemName: "exclamationmark.circle")
            
        default:
            break
        }
        viewAlert.backgroundColor = UIColor(named: type.rawValue)
        image.tintColor = UIColor(named: type.rawValue)
        title.text = type.description()
        self.message.text = message.addLineBreak()
        yes.backgroundColor = viewAlert.backgroundColor
    }
    
    func setupBtnYes(titleYes: String, titleNo: String? = "") {
        yes.isHidden = false
        yes.setTitle(titleYes, for: .normal)
        titleNo?.isEmpty ?? true ? nil : close.setTitle(titleNo, for: .normal)
    }
    
    @IBAction func didTapButton(_ sender: UIButton) {
        if sender == close {
            delegate?.close()
        } else {
            delegate?.yes?()
        }
    }
}
