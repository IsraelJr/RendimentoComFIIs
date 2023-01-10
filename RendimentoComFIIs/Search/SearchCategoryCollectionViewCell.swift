//
//  SearchCollectionViewCell.swift
//  RendimentoComFII
//
//  Created by Israel Alves on 11/04/22.
//

import UIKit

class SearchCategoryCollectionViewCell: UICollectionViewCell {
    
//    @IBOutlet weak var btnCategory: UIButton!
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
//        btnCategory.tintColor = .white
//        btnCategory.layer.cornerRadius = 16
        
        view.layer.cornerRadius = 22
        image.tintColor = .white
        title.textColor = .white
    }
    
    func setData(from segment: FiiSegment) {
//        btnCategory.backgroundColor = segment.category().color
//        btnCategory.setTitle(" \(NSLocalizedString(segment.category().title, comment: "")) ", for: .normal)
//        btnCategory.setImage(segment.category().image, for: .normal)
        view.backgroundColor = segment.category().color
        title.text = "\(NSLocalizedString(segment.category().title, comment: ""))"
        image.image = segment.category().image
    }
    
}
