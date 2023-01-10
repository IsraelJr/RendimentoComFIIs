//
//  AboutCollectionViewCell.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 29/11/22.
//

import UIKit

struct AboutWallet {
    var image: UIImage!
    var title: String!
    var description: String!
}

class AboutCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var viewBar: UIView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        
        setupLayout()
        
    }
    
    private func setupLayout() {
        self.backgroundColor = .systemBackground
        
        let size = UIScreen.main.bounds.width < 390 ? 230 : image.frame.size.width
        image.contentMode = .scaleAspectFill
        image.frame.size = CGSize(width: size, height: size)
        image.size(CGSize(width: size, height: size))
        image.layer.cornerRadius = image.frame.width / 2
        
        viewBar.layer.cornerRadius = 4
        viewBar.backgroundColor = .systemGray6
        
        labelTitle.font = UIFont.boldSystemFont(ofSize: UIScreen.main.bounds.width < 390 ? 24 : 28)
        labelTitle.textColor = UIColor(named: "Font")
        labelTitle.textAlignment = .center
        labelTitle.numberOfLines = 2
        labelTitle.adjustsFontSizeToFitWidth = true
        labelTitle.minimumScaleFactor = 0.1
        
        labelDescription.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width < 390 ? 16 : 20)
        labelDescription.textColor = .gray
        labelDescription.textAlignment = .center
        labelDescription.adjustsFontSizeToFitWidth = true
        labelDescription.minimumScaleFactor = 0.1
        labelDescription.numberOfLines = 0
        labelDescription.baselineAdjustment = .none
    }
    
    func setData(_ data: AboutWallet) {
        image.image = data.image
        labelTitle.text = data.title
        labelDescription.text = data.description
    }
}
