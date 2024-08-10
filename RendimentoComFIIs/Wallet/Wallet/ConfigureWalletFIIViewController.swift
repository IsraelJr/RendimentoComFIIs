//
//  ConfigureWalletFIIViewController.swift
//  RendimentoComFII
//
//  Created by Israel Alves on 25/04/22.
//

import UIKit

enum InsertObject {
    case fii
    case month
}

class ConfigureWalletFIIViewController: UIViewController {
    
    @IBOutlet var collectionLabel: [UILabel]!
    @IBOutlet var collectionTextField: [UITextField]!
    @IBOutlet var collectionButton: [UIButton]!
    @IBOutlet weak var viewMain: UIView!
    
    var code = ""
    var currentQuotas = ""
    var btnInTheWallet: UIButton?
    var vcWallet: UIViewController?
    var insert: InsertObject?
    var comeBack = false
    var validatedDataCom: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        addDoneButtonOnKeyboard()
    }
    
    private func setupLayout() {
        view.backgroundColor = .clear
        
        viewMain.backgroundColor = .systemGray6
        viewMain.layer.cornerRadius = 24
        
        collectionLabel.forEach({
            $0.font = UIFont.boldSystemFont(ofSize: 16)
            $0.numberOfLines = 2
            $0.adjustsFontSizeToFitWidth = true
            $0.minimumScaleFactor = 0.1
            switch $0 {
            case collectionLabel.first:
                $0.text = title
                $0.textAlignment = .center
                $0.font = UIFont.boldSystemFont(ofSize: 24)
                
            case collectionLabel[1]:
                $0.text = insert == .fii ? NSLocalizedString("select_fii", comment: "") : NSLocalizedString("select_month", comment: "")
                
            case collectionLabel[2]:
                $0.text = insert == .fii ? NSLocalizedString("total_quotas", comment: "") : NSLocalizedString("total_earnings", comment: "")
                
            case collectionLabel.last:
                $0.font = UIFont.boldSystemFont(ofSize: 12)
                $0.textColor = .lightGray
                $0.text = insert == .fii ? NSLocalizedString("note1", comment: "") : ""
                
            default:
                break
            }
        })
        
        collectionTextField.forEach({
            $0.delegate = self
            $0.placeholder = $0 == collectionTextField.first ? NSLocalizedString(insert == .fii ? "enter_fii_code" : "enter_month", comment: "") : NSLocalizedString(insert == .fii ? "enter_total_quotas" : "enter_total_earnings", comment: "")
            $0.keyboardType = $0 == collectionTextField.first ? .alphabet : (insert == .fii ? .numberPad : .decimalPad)
            $0.returnKeyType = .next
            $0.text = $0 == collectionTextField.first ? code.trimmingCharacters(in: .whitespacesAndNewlines) : "\(currentQuotas)".trimmingCharacters(in: .whitespacesAndNewlines)
            $0.isEnabled = ($0 == collectionTextField.first && $0.text?.isEmpty == false) ? false : true
            $0.textColor = $0.isEnabled ? .label : .lightGray
        })
        
        collectionButton.forEach({
            $0 == collectionButton.first ? $0.setTitle(NSLocalizedString("save", comment: ""), for: .normal) : $0.setTitle("  \(NSLocalizedString("follow", comment: ""))", for: .normal)
            $0.tag = 1
            $0 == collectionButton.last ? didTapJustFollow($0) : nil
            insert != .fii ? collectionButton.last?.isHidden = true : nil
            
        })
        currentQuotas = collectionTextField.last?.text ?? Int().description
        
    }
    
    private func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle       = UIBarStyle.default
        let flexSpace              = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem  = UIBarButtonItem(title: NSLocalizedString("done", comment: ""), style: UIBarButtonItem.Style.done, target: self, action: #selector(self.doneKeyboardNumber))
        done.tintColor = UIColor(named: "Font")
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        collectionTextField.last?.inputAccessoryView = doneToolbar
        
    }
    
    private func insertFii() {
        if let nameFii = collectionTextField.first?.text, nameFii.isEmpty == false, let quotas = collectionTextField.last?.text, Int64(quotas) ?? 0 > 0 {
            
            let month = NSLocalizedString(String(Util.currentDate().split(separator: "/")[1]), comment: "")
            let dataWith = ListFii.listFiis.first(where: {$0.code.elementsEqual(nameFii)})?.earnings?.first(where: {$0.key.elementsEqual(month)})?.value.first(where: {$0.key.elementsEqual("date_with")})?.value as? String
            
            if let result = dataWith?.isGreaterCurrentDate(), !result, Int(quotas) ?? .zero != Int(currentQuotas) {
                comeBack = true
                validatedDataCom = true
                let ask = NSLocalizedString("ask_about_date_with", comment: "").replacingOccurrences(of: "[date]", with: dataWith!)
                let alert = alertView(type: .warning, message: ask)
                alert.setupBtnYes(titleYes: NSLocalizedString("ask_about_date_with_opt_yes", comment: ""),
                                  titleNo: NSLocalizedString("ask_about_date_with_opt_no", comment: ""))
                alert.delegate = self
            } else {
            _ = Util.userDefaultForWallet(action: .create, code: nameFii, quotas: quotas)
                dismissWith(.fade)
            }
            
        } else {
            if collectionButton.last?.tag == 0 {
                btnInTheWallet?.didTapAddToWallet(codeFii: collectionTextField.first!.text!, action: .delete)
            } else {
                _ = Util.userDefaultForWallet(action: .create, code: collectionTextField.first!.text!, quotas: currentQuotas)
            }
            dismissWith(.fade)
        }
        vcWallet?.viewWillAppear(true)
    }
    
    private func insertMonth() {
        if let month = collectionTextField.first?.text?.firstLetterUppercased(), let earnings = collectionTextField.last?.text?.convertCurrencyToDouble(), earnings > 0.0 {
            if Month.allCases.first(where: { $0.description().0.elementsEqual(NSLocalizedString(month, comment: "")) }) == nil {
                alertView(type: .error, message: NSLocalizedString("month_invalid", comment: "")).delegate = self
            } else {
                _ = Util.userDefaultForMonth(action: .create, month, earnings)
                dismissWith(.fade)
                (vcWallet as! WalletHistoricViewController).updateMonth = month
                vcWallet?.viewWillAppear(true)
            }
        } else {
            alertView(type: .warning, message: NSLocalizedString("invalid_data", comment: "")).delegate = self
            comeBack = true
        }
    }
    
    private func updateQuotas() {
        var action = CRUD.create
        if let result = validatedDataCom, !result {
            action = .updtate
        }
        _ = Util.userDefaultForWallet(action: action, code: collectionTextField.first!.text, quotas: collectionTextField.last!.text)

    }
    
    @objc func doneKeyboardNumber() {
        view.closeKeyboard()
    }
    
    @IBAction func didTpapSave(_ sender: UIButton) {
        switch insert {
        case .month:
            insertMonth()
            
        case .fii:
            insertFii()
            
        default:
            break
        }
        
    }
    
    @IBAction func didTapJustFollow(_ sender: UIButton) {
        if sender.tag == 0 {
            sender.tag = 1
            sender.tintColor = collectionButton.first?.tintColor  //UIColor().colorRadioActive
            sender.setImage(UIImage(systemName: "checkmark.rectangle.fill"), for: .normal)
        } else {
            sender.tag = 0
            sender.tintColor = UIColor().colorRadioDisabled
            sender.setImage(UIImage(systemName: "rectangle.fill"), for: .normal)
        }
    }
    
}


extension ConfigureWalletFIIViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == collectionTextField.first {
            collectionTextField.last?.becomeFirstResponder()
        }
        return true
    }
}


extension ConfigureWalletFIIViewController: ActionButtonAlertDelegate {
    func close() {
        dismiss(animated: true) { [self] in
            if let result = validatedDataCom, result {
                validatedDataCom = false
                alertView(type: .info, message: NSLocalizedString("response_about_date_with_opt_no", comment: "")).delegate = self
            } else {
                validatedDataCom ?? true ? nil : updateQuotas()
                self.comeBack ? self.dismiss(animated: true) : nil
            }
        }
    }

    func yes() {
        updateQuotas()
        dismiss(animated: true) {
            self.comeBack ? self.dismissWith(.fade) : nil
        }
    }
}

