//
//  TopDYCollectionViewCell.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

class TopDYCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet var collectionLabel: [UILabel]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = .systemGray6
        self.layer.cornerRadius = 24
        
        collectionLabel.forEach({
            $0.textAlignment = .center
            $0.font = UIFont.boldSystemFont(ofSize: 24)
            $0.numberOfLines = 1
            $0.minimumScaleFactor = 0.1
            $0.adjustsFontSizeToFitWidth = true
            $0.textColor = .white
        })
        
        collectionLabel[1].font = UIFont.boldSystemFont(ofSize: 16)
        collectionLabel[1].numberOfLines = 6
        
        collectionLabel[2].font = collectionLabel[1].font
        collectionLabel[2].textAlignment = .right
        
        collectionLabel[3].font = UIFont.boldSystemFont(ofSize: 12)
        collectionLabel[3].textAlignment = .center
    }
    
    func setFii(_ fii: FIIModel.Fetch.FII) {
        collectionLabel[0].text = fii.code
        collectionLabel[1].text = fii.socialReason
        collectionLabel[2].text = fii.price
        collectionLabel[3].text = fii.dividendYield
    }
}

