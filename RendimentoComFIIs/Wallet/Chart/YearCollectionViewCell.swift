//
//  YearCollectionViewCell.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 31/05/22.
//

import UIKit

class YearCollectionViewCell: UICollectionViewCell {
 
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        self.isSelected = true
        
        viewBackground.backgroundColor = .lightGray
        viewBackground.layer.cornerRadius = 16
        
        title.textColor = .white
        title.backgroundColor = .clear
        title.font = UIFont.boldSystemFont(ofSize: 16)
        title.adjustsFontSizeToFitWidth = true
        title.minimumScaleFactor = 0.1
        title.numberOfLines = 1
        title.textAlignment = .center
    }
    
    func setData(from name: String) {
        title.text = NSLocalizedString(name, comment: "")
    }
    
}
