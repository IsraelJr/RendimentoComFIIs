//
//  DetailDescriptionViewController.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 27/04/22.
//

import UIKit

class DetailDescriptionViewController: UIViewController {

    @IBOutlet weak var viewHeader: NavigationBarHeaderView!
    @IBOutlet weak var tvDescription: UITextView!
    
    var desc = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewHeader.setTitleHeader(name: self.title ?? "")
        viewHeader.btnReturn.isHidden = true
        
        tvDescription.font = UIFont.systemFont(ofSize: 16)
        tvDescription.isEditable = false
        tvDescription.text = desc.addLineBreak()
        
//        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
//        swipeRight.direction = .right
//        self.view.addGestureRecognizer(swipeRight)
        
    }
    
//    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
//        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
//
//            switch swipeGesture.direction {
//            case .right:
//                self.dismissWith()
//            default:
//                break
//            }
//        }
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = UIInterfaceOrientationMask.all
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = UIInterfaceOrientationMask.portrait
        }
    }
    
    
}
