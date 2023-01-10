//
//  MoreOptionsWalletTableViewCell.swift
//  RendimentoComFII
//
//  Created by Israel Alves on 05/04/22.
//

import UIKit

class MoreOptionsWalletCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var pro: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        
        viewMain.backgroundColor = .white //UIColor(named: "Border")
        viewMain.layer.cornerRadius = 16
        
        img.contentMode = .scaleAspectFit
        img.clipsToBounds = true
        
        title.textColor = .lightGray
        title.font = UIFont.boldSystemFont(ofSize: 16)
        title.adjustsFontSizeToFitWidth = true
        title.minimumScaleFactor = 0.1
        title.numberOfLines = 1
        title.textAlignment = .center
        
        pro.isHidden = true
    }
    
    func setData(from name: String) {
        title.text = NSLocalizedString(name, comment: "")
        img.image = UIImage(named: name.lowercased())
    }
    
}
