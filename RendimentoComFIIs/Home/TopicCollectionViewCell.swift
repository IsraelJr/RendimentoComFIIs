//
//  TopicCollectionViewCell.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 02/05/22.
//

import UIKit

class TopicCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageBackground: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var imgItemFlagNew: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = .systemBackground
        self.layer.cornerRadius = 16
        
        imageBackground.contentMode = .scaleAspectFill
        
        labelTitle.textColor = .white
        labelTitle.textAlignment = .center
        labelTitle.lineBreakMode = .byWordWrapping
        labelTitle.numberOfLines = 2
        labelTitle.adjustsFontSizeToFitWidth = true
        labelTitle.minimumScaleFactor = 0.1
        
        imgItemFlagNew.image = UIImage(systemName: "exclamationmark.circle.fill")
        imgItemFlagNew.tintColor = UIColor(named: AlertType.warning.rawValue)
        setItemFlagNew(true)
    }
    
    func setData(from item: (String, String)) {
        imageBackground.image = UIImage(data: Data(base64Encoded: item.0)!)
        labelTitle.text = NSLocalizedString(item.1, comment: "")
    }
    
    func setItemFlagNew(_ hide: Bool!) {
        imgItemFlagNew.isHidden = hide
    }
    
}
