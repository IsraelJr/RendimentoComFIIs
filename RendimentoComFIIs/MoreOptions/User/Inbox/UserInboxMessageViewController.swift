//
//  ViewController.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

class UserInboxMessageViewController: UIViewController {
    
    @IBOutlet weak var viewHeader: NavigationBarHeaderView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var tvMessage: UITextView!
    
    var objMessage: UserInboxModel.Fetch.Message?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupLayout()
    }
    
    private func setupLayout() {
        viewHeader.setTitleHeader(name: self.title ?? "")
        viewHeader.btnReturn.isHidden = true
        
        lbTitle.text = objMessage?.title ?? ""
        lbTitle.font = UIFont.boldSystemFont(ofSize: 18)
        lbTitle.textAlignment = .left
        lbTitle.numberOfLines = 0
        lbTitle.textColor = .gray
        
        labelDate.text = Util.compareDateIsEqualDateCurrent(dateString: objMessage?.date ?? "") ? NSLocalizedString("today", comment: "") : objMessage?.date
        labelDate.font = UIFont.boldSystemFont(ofSize: 16)
        labelDate.textAlignment = .right
        labelDate.textColor = lbTitle.textColor
        
        tvMessage.text = (objMessage?.description ?? "").addLineBreak()
        tvMessage.font = UIFont.systemFont(ofSize: 20)
        tvMessage.textColor = lbTitle.textColor
        
    }
    
    
}
