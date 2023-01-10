//
//  TermsViewController.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 16/05/22.
//

import UIKit
import FirebaseFirestore

class TermsViewController: UIViewController {

    @IBOutlet weak var viewHeader: NavigationBarHeaderView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var tvDescription: UITextView!
    
    var desc = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    private func setupLayout() {
        viewHeader.delegate = self
        viewHeader.setTitleHeader(name: "      \(NSLocalizedString("terms_title", comment: ""))")
        
        lbTitle.numberOfLines = 0
        lbTitle.font = UIFont.boldSystemFont(ofSize: 24)
        lbTitle.text = title
        lbTitle.text = LoginViewController.terms?.title ?? ""
        
        tvDescription.isEditable = false
        tvDescription.text = LoginViewController.terms?.description?.addLineBreak() ?? ""
        
    }
}


extension TermsViewController: NavigationBarHeaderDelegate {
    func didTapButtonBack(_ sender: UIButton) {
        dismissWith()
    }
    
    
}
