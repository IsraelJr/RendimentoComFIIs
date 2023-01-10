//
//  ConfigureNewsViewController.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 04/04/22.
//

import UIKit

class ConfigureNewsViewController: UIViewController {
    
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet var collectionLabel: [UILabel]!
    @IBOutlet var collectionSwitch: [UISwitch]!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet var collectionRadio: [UIButton]!
    @IBOutlet var collectionCheckbox: [UIButton]!
    
    enum Questions: String, CaseIterable {
        case config_news
        case change_news
        case download_news
        case total_news
        case news_sites
        
        func description() -> String {
            return NSLocalizedString(self.rawValue, comment: "")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        view.backgroundColor = .clear
        
        viewMain.backgroundColor = .systemGray6
        viewMain.layer.cornerRadius = 24
        
        for i in 0..<collectionLabel.count {
            collectionLabel[i].numberOfLines = 3
            collectionLabel[i].adjustsFontSizeToFitWidth = true
            collectionLabel[i].minimumScaleFactor = 0.1
            collectionLabel[i].font = UIFont.boldSystemFont(ofSize: 16)
            collectionLabel[i].text = Questions.allCases[i].description()
        }
        
        collectionLabel[0].font = UIFont.boldSystemFont(ofSize: 24)
        collectionLabel[0].numberOfLines = 1
        collectionLabel[0].textAlignment = .center
        
        var value = 5
        collectionRadio.forEach({
            $0.setupDefault(35, "circle.circle", "  \(value)")
            value += 5
        })
        switch UserDefaultKeys.totalNews.getValue() as! Int {
        case 5:
            didTapRadio(collectionRadio[0])
        case 15:
            didTapRadio(collectionRadio[2])
        default:
            didTapRadio(collectionRadio[1])
        }
        
        collectionCheckbox.forEach({
            NSLayoutConstraint.activate([
                $0.heightAnchor.constraint(equalToConstant: 40)
            ])
            didTapCheckbox($0)
            $0.isEnabled = $0 == collectionCheckbox[3] ? false : true
        })
        
        for i in 0..<collectionCheckbox.count {
            collectionCheckbox[i].setTitle("\(Sites.allCases[i].rawValue.uppercased())", for: .normal)
            collectionCheckbox[i].tag = UserDefaults.standard.string(forKey: collectionCheckbox[i].currentTitle!.lowercased()) ?? "1" == "1" ? 0 : 1
            didTapCheckbox(collectionCheckbox[i])
        }
        
        let s0 = UserDefaults.standard.string(forKey: UserDefaultKeys.changeNews.rawValue)
        let s1 = UserDefaults.standard.string(forKey: UserDefaultKeys.downloadNews.rawValue)
        collectionSwitch[0].isOn = (s0 == nil ? true.description : s0)!.elementsEqual(true.description) ? true : false
        collectionSwitch[1].isOn = (s1 == nil ? true.description : s1)!.elementsEqual(true.description) ? true : false
        
        collectionSwitch.forEach({ didTapSwitch($0) })
        
        btnClose.setTitle(NSLocalizedString("save", comment: ""), for: .normal)
    }
    
    private func checkTotalSites() -> Bool {
        var total = 0
        collectionCheckbox.forEach({ total += $0.tag })
        return total > 1 ? true : false
    }
    
    @IBAction func didTapSwitch(_ sender: UISwitch) {
        if sender.isOn {
            sender.onTintColor = UIColor().colorRadioActive
        } else {
            sender.tintColor = .systemRed
            sender.layer.cornerRadius = sender.frame.height / 2.0
            sender.backgroundColor = .systemRed
            sender.clipsToBounds = true
        }
        
        sender == collectionSwitch[0] ? UserDefaults.standard.set(sender.isOn ? true.description : false.description, forKey: UserDefaultKeys.changeNews.rawValue) : UserDefaults.standard.set(sender.isOn ? true.description : false.description, forKey: UserDefaultKeys.downloadNews.rawValue)
    }
    
    @IBAction func didTapRadio(_ sender: UIButton) {
        collectionRadio.forEach({
            $0 == sender ? $0.setImage(UIImage(systemName: "circle.circle.fill"), for: .normal) : $0.setImage(UIImage(systemName: "circle.circle"), for: .normal)
            $0.tintColor = $0 == sender ? UIColor().colorRadioActive : UIColor().colorRadioDisabled
            UserDefaults.standard.set(Int(sender.currentTitle?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "0"), forKey: UserDefaultKeys.totalNews.rawValue)
        })
        
    }
    
    @IBAction func didTapCheckbox(_ sender: UIButton) {
        if sender.tag == 0 {
            sender.tag = 1
            sender.tintColor = UIColor().colorRadioActive
            sender.setImage(UIImage(systemName: "checkmark.rectangle.fill"), for: .normal)
            UserDefaults.standard.set(true, forKey: sender.currentTitle?.lowercased() ?? "")
        } else {
            if checkTotalSites() {
                sender.tag = 0
                sender.tintColor = UIColor().colorRadioDisabled
                sender.setImage(UIImage(systemName: "rectangle.fill"), for: .normal)
                UserDefaults.standard.set(false, forKey: sender.currentTitle?.lowercased() ?? "")
            } else {
                self.alertView(type: .warning, message: "É obrigatório manter pelo menos um site de notícia.").delegate = self
            }
        }
    }
    
    @IBAction func didTapSave(_ sender: UIButton) {
        dismissWith(.fade)
    }
}


extension ConfigureNewsViewController: ActionButtonAlertDelegate {
    func close() {
        dismiss(animated: true)
    }
    
    
}
