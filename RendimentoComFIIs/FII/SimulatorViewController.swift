//
//  SimulatorViewController.swift
//  RendimentoComFII
//
//  Created by Israel Alves on 21/04/22.
//

import UIKit

class SimulatorViewController: UIViewController {
    
    @IBOutlet weak var viewHeader: NavigationBarHeaderView!
    @IBOutlet var collectionView: [UIView]!
    @IBOutlet var collectionLabelTitle: [UILabel]!
    @IBOutlet var collectionTextField: [UITextField]!
    @IBOutlet weak var btnCalculate: UIButton!
    
    let desc = "devo investir um valor de 999 reais que dariam uma quantidade de XX cotas."
    var obj: FIIModel.Fetch.FII?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
    }
    
    private func setupLayout() {
        viewHeader.delegate = self
        viewHeader.setTitleHeader(name: NSLocalizedString("simulator", comment: ""))
        
        collectionView.forEach({
            $0.layer.cornerRadius = 16
        })
        
        collectionLabelTitle.forEach({
            $0.numberOfLines = 0
            $0.lineBreakMode = .byWordWrapping
            $0.font = UIFont.boldSystemFont(ofSize: 16)
        })
        
        collectionLabelTitle[0].numberOfLines = 2
        collectionLabelTitle[0].text = "Para receber proventos de"
        collectionLabelTitle[1].text = "R$"
        collectionLabelTitle[2].text = "do Fundo Imobiliário"
        collectionLabelTitle[3].isHidden = true
        collectionTextField.forEach({
            $0.delegate = self
            $0.textAlignment = .right
            $0.textColor = .gray
            $0.font = UIFont.boldSystemFont(ofSize: 16)
            $0.keyboardType = $0 == collectionTextField.first ? .decimalPad : .alphabet
            $0.returnKeyType = $0 == collectionTextField.first ? .default : .done
            $0.placeholder = $0 == collectionTextField.first ? "0,0" : ""
            $0.delegate = self
        })
        
        collectionTextField.last?.text = obj?.code.uppercased() ?? ""
        
        btnCalculate.setTitle(NSLocalizedString("calculate", comment: ""), for: .normal)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    private func isValidFII() -> Bool {
        guard let code = collectionTextField.last?.text else { return false}
        return (ListFii.listFiis.first(where: {$0.code.elementsEqual(code.uppercased())}) != nil)
    }
    
    private func calcular() {
        if !(collectionTextField[0].text?.isEmpty ?? true) && !(collectionTextField[1].text?.isEmpty ?? true) {
            DispatchQueue.main.async { [self] in
                let earning = (obj?.earnings?.first(where: {$0.key.elementsEqual(Month.current.description().0)})?.value.first(where: {$0.key.elementsEqual("earnings")})?.value as? String ?? "0.0").convertCurrencyToDouble()
                let price = quoteList.first(where: {$0.code.elementsEqual(collectionTextField.last?.text ?? "")})?.currentPrice.convertCurrencyToDouble()
                let data = Util.calculationToReceiveEarnings(to: .init(targetValue: collectionTextField[0].text!.convertCurrencyToDouble(), priceCurrent: price ?? 0.0 , currentMonthEarnings: earning))
                collectionLabelTitle[collectionLabelTitle.count-1].text? = desc.replacingOccurrences(of: "999", with: "\(data.estimatedValue)").replacingOccurrences(of: "XX", with: "\(data.totalQuotas)")
                collectionLabelTitle[collectionLabelTitle.count-1].isHidden = false
                //                collectionTextField.first?.text = (collectionTextField.first?.text?.convertCurrencyToDouble() ?? 0.0).convertToCurrency()
            }
        }
    }
    
    private func showAlert() {
        if collectionTextField.last?.text?.count ?? 0 > 0 {
            _ = self.alertView(type: .warning, message: NSLocalizedString("fii_not_found", comment: "").replacingOccurrences(of: "xxx", with: collectionTextField.last?.text ?? "")).delegate = self
        }
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
            case .right:
                self.dismissWith()
            default:
                break
            }
        }
    }
    
    @IBAction func didTapCalculate(_ sender: Any) {
        collectionTextField.forEach({$0.resignFirstResponder()})
        if isValidFII() {
            obj = ListFii.listFiis.first(where: {$0.code.elementsEqual(collectionTextField.last?.text ?? "")})
            calcular()
        } else {
            showAlert()
        }
        
    }
    
}


extension SimulatorViewController: NavigationBarHeaderDelegate {
    func didTapButtonBack(_ sender: UIButton) {
        self.dismissWith()
    }
}


extension SimulatorViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if (isBackSpace == -92) {
                return true
            }
        }
        
        if textField == collectionTextField.last {
            if !updatedText.isEmpty, updatedText.count <= 9 {
                textField.text = updatedText.uppercased()
                return false
            } else {
                return false
            }
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        textField.text = text.uppercased()
        if textField == collectionTextField.first {
            collectionTextField.first?.text = (collectionTextField.first?.text?.convertCurrencyToDouble() ?? 0.0).convertToCurrency()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if collectionTextField.first?.text?.isEmpty ?? true {
            collectionTextField.first?.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}

extension SimulatorViewController: ActionButtonAlertDelegate {
    func close() {
        dismiss(animated: true)
    }
}
