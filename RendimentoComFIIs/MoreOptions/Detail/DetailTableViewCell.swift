//
//  MoreOptionsTableViewCell.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 05/04/22.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var imgItemFlagNew: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        self.layer.cornerRadius = 16
        
        view.layer.cornerRadius = self.layer.cornerRadius
        
        title.numberOfLines = 2
        title.adjustsFontSizeToFitWidth = true
        title.minimumScaleFactor = 0.1
        
        imgItemFlagNew.image = UIImage(systemName: "exclamationmark.circle.fill")
        imgItemFlagNew.tintColor = UIColor(named: AlertType.warning.rawValue)
        imgItemFlagNew.isHidden = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setData(from name: String, _ isNew: Bool? = false, _ isUpdated: Bool? = false) {
        title.text = name
        imgItemFlagNew.isHidden = (isNew ?? false || isUpdated ?? false) ? false : true
    }
}
