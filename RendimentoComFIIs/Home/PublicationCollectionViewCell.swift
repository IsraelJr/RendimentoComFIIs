//
//  PublicationCollectionViewCell.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 31/03/22.
//

import UIKit

class PublicationCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet var collectionLabels: [UILabel]!
    
    var urlSite = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        img.contentMode = .scaleAspectFill
        
        collectionLabels.forEach({
            $0.font = UIFont.boldSystemFont(ofSize: 12)
            $0.numberOfLines = 1
            $0.textColor = .white
            $0.adjustsFontSizeToFitWidth = true
            $0.minimumScaleFactor = 0.1
        })
        
        collectionLabels[0].numberOfLines = 4
        collectionLabels[0].font = UIFont.boldSystemFont(ofSize: 24)
        
        collectionLabels[1].textAlignment = .right
        
        collectionLabels[2].font = UIFont.boldSystemFont(ofSize: 16)
        
    }
    func setPublication(pub: FiisNews) {
        urlSite = pub.href ?? ""
        img.image = pub.image
        collectionLabels[0].text = pub.title
        collectionLabels[1].text = pub.date
        collectionLabels[2].text = pub.siteName
        
    }
}

