//
//  SummaryMainCell.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 18/08/24.
//

import UIKit

class SummaryMainCell: UITableViewCell {

    static let cellIdentifier = String(describing: SummaryMainCell.self)

        @IBOutlet weak var label: UILabel!
        override func awakeFromNib() {
            super.awakeFromNib()
            // Initialization code
        }

        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)

            // Configure the view for the selected state
        }
    
}
