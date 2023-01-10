//
//  CommentsTableViewCell.swift
//  RendimentoComFII
//
//  Created by Israel Alves on 16/04/22.
//

import UIKit

struct Comments {
    var author: String!
    var comments: String!
    var date: String!
    var site: String!
}

class CommentsTableViewCell: UITableViewCell {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var viewComments: UIView!
    @IBOutlet var collectionLabel: [UILabel]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setup() {
        self.backgroundColor = .clear
        self.layer.cornerRadius = 16
        
        viewMain.layer.cornerRadius = 16
        viewMain.backgroundColor = UIColor(named: "Font")
        
        viewComments.layer.cornerRadius = viewMain.layer.cornerRadius
        
        collectionLabel.forEach({
            $0.font = UIFont.boldSystemFont(ofSize: 14)
            $0.numberOfLines = 5
            $0.lineBreakMode = .byWordWrapping
            $0.text?.removeAll()
        })
        
        collectionLabel[1].font = UIFont.italicSystemFont(ofSize: 16)   //boldSystemFont(ofSize: 16)
        collectionLabel[2].textColor = .gray
        collectionLabel[3].textColor = .white
    }

    func setData(_ comments: Comments) {
        collectionLabel[0].text = comments.author
        collectionLabel[1].text = comments.comments
        collectionLabel[2].text = comments.date
        collectionLabel[3].text = comments.site
    }
}
