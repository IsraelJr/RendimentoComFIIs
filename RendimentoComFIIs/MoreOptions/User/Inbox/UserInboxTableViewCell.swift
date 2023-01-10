//
//  UserInboxTableViewCell.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 05/11/22.
//

import UIKit

class UserInboxTableViewCell: UITableViewCell {

    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var imageOwner: UIImageView!
    @IBOutlet weak var lbOwner: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbMessage: UILabel!
    @IBOutlet weak var viewSignal: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupLayout()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupLayout() {
        self.backgroundColor = .clear
        viewBackground.layer.cornerRadius = 24
        
        imageOwner.layer.cornerRadius = 16
        
        lbOwner.numberOfLines = 1
        lbOwner.adjustsFontSizeToFitWidth = true
        lbOwner.minimumScaleFactor = 0.1
        
        lbTitle.numberOfLines = 1
        lbTitle.adjustsFontSizeToFitWidth = true
        lbTitle.minimumScaleFactor = 0.1
        
        lbDate.numberOfLines = 1
        lbDate.adjustsFontSizeToFitWidth = true
        lbDate.minimumScaleFactor = 0.1
        lbDate.textColor = .gray
        lbDate.textAlignment = .right
     
        lbMessage.numberOfLines = 0
        lbMessage.textColor = lbDate.textColor
        
        viewSignal.layer.cornerRadius = viewSignal.frame.width / 2
    }

    func setData(_ message: UserInboxModel.Fetch.Message) {
        let owner = (message.owner.elementsEqual(InitializationModel.systemName) ? "RF" : "\(message.owner.split(separator: " ").first!.description.firstLetterUppercased().prefix(1))\(message.owner.split(separator: " ")[1].description.firstLetterUppercased().prefix(1))")
        imageOwner.addText(owner)
        lbOwner.text = message.owner
        lbDate.text = Util.compareDateIsEqualDateCurrent(dateString: message.date) ? NSLocalizedString("today", comment: "") : message.date
        lbTitle.text = message.title
        lbMessage.text = message.description
        
        viewBackground.backgroundColor = message.read ? .systemBackground : .label
        viewBackground.alpha = message.read ? 0.5 : 0.9
        lbOwner.textColor = message.read ? .label : .systemBackground
        lbTitle.textColor = lbOwner.textColor
        viewSignal.backgroundColor = message.read ? .clear : .red
    }
    
}
