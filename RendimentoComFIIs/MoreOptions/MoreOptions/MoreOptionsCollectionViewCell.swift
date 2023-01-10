//
//  MoreOptionsTableViewCell.swift
//  RendimentoComFII
//
//  Created by Israel Alves on 05/04/22.
//

import UIKit

class MoreOptionsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        
        viewMain.backgroundColor = UIColor(named: "Border")
        viewMain.layer.cornerRadius = 16
        
        img.contentMode = .scaleAspectFit
        img.clipsToBounds = true
        
        title.textColor = .white
        title.font = UIFont.boldSystemFont(ofSize: 16)
        title.adjustsFontSizeToFitWidth = true
        title.minimumScaleFactor = 0.1
        title.numberOfLines = 1
        title.textAlignment = .center
    }
    
    func setData(from name: String) {
        title.text = NSLocalizedString(name, comment: "")
        img.image = UIImage(named: name.lowercased())
    }
    
}


extension CellContactUs {
    public var titleCell: String? { return NSLocalizedString(self.rawValue, comment: "") }
}

