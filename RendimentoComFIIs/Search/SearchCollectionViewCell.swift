//
//  SearchCollectionViewCell.swift
//  RendimentoComFII
//
//  Created by Israel Alves on 11/04/22.
//

import UIKit

class SearchCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = .clear
        
        viewMain.backgroundColor = UIColor(named: "Border")
        viewMain.layer.cornerRadius = 16
        
        title.font = UIFont.boldSystemFont(ofSize: 20)
        title.textAlignment = .center
        title.textColor = .white
    }
    
    func setData(from code: String) {
        title.text = code
    }
    
}
