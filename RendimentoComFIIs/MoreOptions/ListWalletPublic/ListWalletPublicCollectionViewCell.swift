//
//  WalletPublicTableViewCell.swift
//  RendimentoComFII
//
//  Created by Israel Alves on 05/04/22.
//

import UIKit

class ListWalletPublicCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet var collectionLabel: [UILabel]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        
        viewMain.backgroundColor = .systemBackground
        viewMain.layer.cornerRadius = 16
        viewMain.layer.borderWidth = 3
        
        collectionLabel.forEach {
            $0.font = UIFont.boldSystemFont(ofSize: 18)
            $0.adjustsFontSizeToFitWidth = true
            $0.minimumScaleFactor = 0.1
            $0.numberOfLines = 2
            $0.textAlignment = .center
        }
        
    }
    
    func setData(_ data: (fii: String, segment: String)) {
        collectionLabel.first?.text = data.fii
        collectionLabel.last?.text = data.segment
        collectionLabel.forEach( {$0.textColor = .lightGray} )
        viewMain.layer.borderColor = UIColor.clear.cgColor
    }
    
}
