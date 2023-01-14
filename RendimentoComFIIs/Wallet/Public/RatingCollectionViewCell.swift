//
//  RatingTableViewCell.swift
//  RendimentoComFII
//
//  Created by Israel Alves on 05/04/22.
//

import UIKit

class RatingCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        
        viewMain.backgroundColor = .white
        viewMain.layer.cornerRadius = 16
        viewMain.layer.borderWidth = 3
        viewMain.layer.borderColor = UIColor.clear.cgColor
        
        title.textColor = .lightGray
        title.font = UIFont.boldSystemFont(ofSize: 18)
        title.adjustsFontSizeToFitWidth = true
        title.minimumScaleFactor = 0.1
        title.numberOfLines = 1
        title.textAlignment = .center
        
    }
    
    func setData(_ name: String) {
        title.text = name
    }
    
}
