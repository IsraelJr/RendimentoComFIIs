//
//  NewsTableViewCell.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 02/07/22.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet var collectionLabel: [UILabel]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        self.layer.cornerRadius = 16
        
        viewMain.layer.cornerRadius = self.layer.cornerRadius
        
        img.contentMode = .scaleAspectFill
        
        collectionLabel.forEach({
            $0.font = UIFont.boldSystemFont(ofSize: 12)
            $0.numberOfLines = 1
            $0.textColor = .white
            $0.adjustsFontSizeToFitWidth = true
            $0.minimumScaleFactor = 0.1
        })
        
        collectionLabel.first!.font = UIFont.boldSystemFont(ofSize: 16)
        
        collectionLabel[1].numberOfLines = 4
        collectionLabel[1].font = UIFont.boldSystemFont(ofSize: 24)
        
        collectionLabel.last!.textAlignment = .right
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setData(obj: NewsletterModel.Fetch.Newsletter) {
        img.image = obj.image
        collectionLabel.first!.text = obj.siteName
        collectionLabel[1].text = obj.title
        collectionLabel.last!.text = obj.date
    }
}
