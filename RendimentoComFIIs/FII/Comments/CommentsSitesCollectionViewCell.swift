//
//  CommentsSitesCollectionViewCell.swift
//  RendimentoComFII
//
//  Created by Israel Alves on 16/04/22.
//

import UIKit

class CommentsSitesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgSite: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = .clear
        
        imgSite.contentMode = .scaleAspectFill
        imgSite.layer.cornerRadius = imgSite.frame.width / 2
        imgSite.layer.borderColor = UIColor(named: "Font")?.cgColor
        imgSite.layer.borderWidth = 2
    }
    
    func setImage(from image: String) {
        imgSite.image = UIImage(named: image)
    }
    
}
