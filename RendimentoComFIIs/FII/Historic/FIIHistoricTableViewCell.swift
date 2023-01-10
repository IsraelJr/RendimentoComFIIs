//
//  FIIHistoricTableViewCell.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 05/06/22.
//

import UIKit

class FIIHistoricTableViewCell: UITableViewCell {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lbValue: UILabel!
    @IBOutlet weak var cdi: UILabel!
//    @IBOutlet weak var ipca: UILabel!
    
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
        
        lbValue.numberOfLines = 1
        lbValue.adjustsFontSizeToFitWidth = true
        lbValue.minimumScaleFactor = 0.1
        lbValue.font = UIFont.boldSystemFont(ofSize: 16)
        
        cdi.numberOfLines = 1
        cdi.adjustsFontSizeToFitWidth = true
        cdi.minimumScaleFactor = 0.1
        cdi.textAlignment = .right
        cdi.font = UIFont.boldSystemFont(ofSize: 16)
        cdi.isHidden = true
        
//        ipca.numberOfLines = cdi.numberOfLines
//        ipca.adjustsFontSizeToFitWidth = cdi.adjustsFontSizeToFitWidth
//        ipca.minimumScaleFactor = cdi.minimumScaleFactor
//        ipca.textAlignment = cdi.textAlignment
//        ipca.font = cdi.font
//        ipca.isHidden = cdi.isHidden
        
    }
    
    func setData(_ year: String, _ data: (String, Double, String)) {
        img.addText(NSLocalizedString(data.0, comment: ""))
        lbValue.text = data.1.convertToCurrency(true)
        lbValue.textAlignment = .right
//        if !year.elementsEqual(Util.currentYear) {
//            cdi.isHidden = true
//            ipca.isHidden = cdi.isHidden
            cdi.isHidden = false
//            return
//        }
        lbValue.textAlignment = .right
        let valueCDI = InitializationModel.dataIndexes.cdi?.months.first(where: {$0.self.description.contains(NSLocalizedString(Locale.current.languageCode?.elementsEqual("pt") ?? true ? data.0 : NSLocalizedString("\(data.0)ToPt", comment: ""), comment: ""))})
        let valueIPCA = InitializationModel.dataIndexes.ipca?.months.first(where: {$0.self.description.contains(NSLocalizedString(Locale.current.languageCode?.elementsEqual("pt") ?? true ? data.0 : NSLocalizedString("\(data.0)ToPt", comment: ""), comment: ""))})
        cdi.text = "CDI: \(valueCDI?.first?.value ?? "")"
//        ipca.text = "IPCA: \(valueIPCA?.first?.value ?? "")"
        print(InitializationModel.dataIndexes.cdi?.months.forEach({print($0.self)}) ?? "")
        print("\n=======================================================================\n")
        print(InitializationModel.dataIndexes.inpc?.months.forEach({print($0.self)}) ?? "")
        print("\n=======================================================================\n")
        print(InitializationModel.dataIndexes.igpm?.months.forEach({print($0.self)}) ?? "")
        print("\n=======================================================================\n")
        print(InitializationModel.dataIndexes.ipca?.months.forEach({print($0.self)}) ?? "")
        
//        cdi.isHidden = true
//        ipca.isHidden = cdi.isHidden
        cdi.text = data.2
        cdi.isHidden = false
    }
    
    func setYear(_ data: (String, Double)) {
        img.addText(data.0)
        lbValue.text = data.1.convertToCurrency(true)
        lbValue.textAlignment = .right
        cdi.isHidden = true
//        ipca.isHidden = cdi.isHidden
    }
}
