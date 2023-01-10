//
//  WalletTableViewCell.swift
//  RendimentoComFII
//
//  Created by Israel Alves on 24/04/22.
//

import UIKit

protocol ActionButtonEditDelegate {
    func didTapEditQuotas(_ sender: UIButton)
}

struct EditFii {
    var title: String
    var code: String
    var quotas: String
}

class WalletTableViewCell: UITableViewCell {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lbQuotas: UILabel!
    @IBOutlet weak var lbValue: UILabel?
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var lbLastUpdate: UILabel?
    
    var delegate: ActionButtonEditDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    private func setup() {
        self.backgroundColor = .clear
        self.selectionStyle = .none
        
        viewMain.layer.cornerRadius = 16
        
        lbQuotas.numberOfLines = 1
        lbQuotas.adjustsFontSizeToFitWidth = true
        lbQuotas.minimumScaleFactor = 0.1
        lbQuotas.textAlignment = .center
        lbQuotas.font = UIFont.boldSystemFont(ofSize: 16)
        
        lbValue?.numberOfLines = 1
        lbValue?.adjustsFontSizeToFitWidth = true
        lbValue?.minimumScaleFactor = 0.1
        lbValue?.textAlignment = .center
        lbValue?.font = UIFont.boldSystemFont(ofSize: 16)
        
        btnEdit.setupDefault(45, "pencil.circle")
        btnEdit.setPreferredSymbolConfiguration(.init(scale: .large), forImageIn: .normal)
        btnEdit.backgroundColor = .systemGray6
        
        lbLastUpdate?.isHidden = true
        lbLastUpdate?.textAlignment = .right
        lbLastUpdate?.textColor = .placeholderText
        lbLastUpdate?.font = UIFont.boldSystemFont(ofSize: 12)
    }
    
    @IBAction func didTapEditQuotas(_ sender: UIButton) {
        sender.pulseEffectInClick()
        delegate?.didTapEditQuotas(sender)
    }
    
    func setData(_ data: (String, Int64)) {
        let color = data.1 == 0 ? UIColor.lightGray : UIColor(named: "mainBlue")
        img.addText(data.0, color)
        lbQuotas.text = "\(data.1) \(NSLocalizedString("quota", comment: ""))"
        let x = ListFii.listFiis.first(where: { $0.code.elementsEqual(data.0) })?.earnings
        let y = x?.first(where: { $0.key.elementsEqual(Month.current.description().0)})?.value.first(where: { $0.key.elementsEqual("earnings") })?.value
        lbValue?.text = (((y as? String) ?? "0.0").convertCurrencyToDouble() * Double(data.1)).convertToCurrency(true)
    }
    
    func setDataHistoric(_ data: (String,Double)) {
        btnEdit.isHidden = true
        img.addText(NSLocalizedString(data.0, comment: ""))
        lbQuotas.text = data.1.convertToCurrency(true)
    }
    
    func setDataQuotes(_ data: (String,String,String)) {
        btnEdit.isHidden = true
        img.addText(NSLocalizedString(data.0, comment: ""))
        lbQuotas.text = data.1
        lbQuotas.textColor = data.1.contains("-") ? UIColor.systemRed : UIColor.systemGreen
        lbLastUpdate?.isHidden = false
        lbLastUpdate?.text = "\(NSLocalizedString("last_update", comment: ""))\(data.2)"
    }
    
    func setDataInbox(_ data: (String,String)) {
        btnEdit.isHidden = true
        img.addText(data.0)
        lbQuotas.text = data.1
    }
}
