//
//  PROViewController.swift
//  RendimentoComFII
//
//  Created by Israel Alves on 12/04/22.
//

import UIKit

class PROViewController: UIViewController {
    
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbDescription: UILabel!
    @IBOutlet weak var lbKeyPIX: UILabel!
    @IBOutlet weak var btnCopyKeyPIX: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        NotificationCenter.default.addObserver(self, selector: #selector(applicationEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        btnCopyKeyPIX.currentTitle?.elementsEqual(NSLocalizedString("send_proof", comment: "")) ?? false ? dismiss(animated: false) : nil
    }
    
    @objc func applicationEnterBackground() {
        btnCopyKeyPIX.currentTitle?.elementsEqual(NSLocalizedString("keycopied", comment: "")) ?? false ? setupLayoutButtonCopyKeyPIX("send_proof") : nil
    }
    
    private func setupLayout() {
        viewMain.backgroundColor = UIColor(named: AlertType.info.rawValue)
        viewMain.layer.cornerRadius = 16
        
        image.backgroundColor = .white
        image.tintColor = viewMain.backgroundColor
        image.layer.cornerRadius = image.frame.width/2
        image.image = UIImage(systemName: "info.circle")
        
        lbTitle.text = NSLocalizedString(UserDefaultKeys.lifetime.getValue() as! Bool ? "titlePRO_2" : "titlePRO_1", comment: "")
        lbTitle.font = UIFont.boldSystemFont(ofSize: 24)
        lbTitle.textAlignment = .center
        lbTitle.textColor = image.backgroundColor
        
        lbDescription.text = NSLocalizedString(UserDefaultKeys.lifetime.getValue() as! Bool ? "descriptionPRO" : "explain_vip", comment: "")
        lbDescription.textAlignment = .center
        lbDescription.adjustsFontSizeToFitWidth = true
        lbDescription.minimumScaleFactor = 0.1
        lbDescription.numberOfLines = 15
        lbDescription.font = UIFont.boldSystemFont(ofSize: 18)
        lbDescription.textColor = image.backgroundColor
        
        lbKeyPIX.text = NSLocalizedString("keypixPRO", comment: "")
        lbKeyPIX.textColor = image.backgroundColor
        lbKeyPIX.font = UIFont.boldSystemFont(ofSize: 16)
        lbKeyPIX.numberOfLines = 2
        lbKeyPIX.adjustsFontSizeToFitWidth = true
        lbKeyPIX.minimumScaleFactor = 0.1
        lbKeyPIX.textAlignment = .center
        
        setupLayoutButtonCopyKeyPIX()
        
        btnClose.setTitle(NSLocalizedString("exit", comment: ""), for: .normal)
        btnClose.backgroundColor = .clear
        btnClose.tintColor = .systemBackground
    }
    
    private func setupLayoutButtonCopyKeyPIX(_ title: String = "") {
        btnCopyKeyPIX.setTitle(NSLocalizedString(title.isEmpty ? "copykeypixPRO" : title, comment: ""), for: .normal)
        btnCopyKeyPIX.backgroundColor = image.backgroundColor
        btnCopyKeyPIX.tintColor = UIColor(named: AlertType.info.rawValue)
        btnCopyKeyPIX.layer.cornerRadius = viewMain.layer.cornerRadius
        btnCopyKeyPIX.layer.borderWidth = 2
        btnCopyKeyPIX.layer.borderColor = btnCopyKeyPIX.tintColor.cgColor
    }
    
    @IBAction func didTapButton(_ sender: UIButton) {
        if sender == btnCopyKeyPIX {
            if (sender.currentTitle?.elementsEqual(NSLocalizedString("copykeypixPRO", comment: "")))! {
                UIPasteboard.general.string = lbKeyPIX.text!
                sender.setTitle(NSLocalizedString("keycopied", comment: ""), for: .normal)
                sender.backgroundColor = sender.tintColor
                sender.tintColor = image.backgroundColor
                sender.layer.borderColor = sender.tintColor.cgColor
            } else {
                segueTo(destination: storyboard?.instantiateViewController(withIdentifier: "contactus") as! ContactUsViewController)
            }
        } else {
            dismissWith(.fade)
        }
    }
}
