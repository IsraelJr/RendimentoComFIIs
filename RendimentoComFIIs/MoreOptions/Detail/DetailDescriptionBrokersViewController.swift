//
//  DetailDescriptionBrokersViewController.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 02/05/22.
//

import UIKit

class DetailDescriptionBrokersViewController: UIViewController {
    
    @IBOutlet weak var viewHeader: NavigationBarHeaderView!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var imgIntitution: UIImageView!
    @IBOutlet var collectionLabel: [UILabel]!
    @IBOutlet weak var btnSeeMore: UIButton!
    @IBOutlet weak var tvAbout: UITextView!
    
    var broker = DetailModel.FetchBrokers.Brokers.init()
    var url = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setBroker()
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
    }
    
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
    
    private func setupLayout() {
        viewHeader.setTitleHeader(name: NSLocalizedString("brokers", comment: ""))
        viewHeader.delegate = self
        viewMain.layer.cornerRadius = 16
        
        imgIntitution.contentMode = .scaleAspectFill
        
        collectionLabel.forEach({
            $0.font = ($0.isEqual(collectionLabel.first) || $0.isEqual(collectionLabel[1])) ? UIFont.boldSystemFont(ofSize: 24) : UIFont.boldSystemFont(ofSize: 16)
            $0.numberOfLines = ($0.isEqual(collectionLabel.first) || $0.isEqual(collectionLabel[1])) ? 4 : 1
            $0.textAlignment = ($0.isEqual(collectionLabel.first) || $0.isEqual(collectionLabel[1])) ? .center : .right
            $0.adjustsFontSizeToFitWidth = true
            $0.minimumScaleFactor = 0.1
            $0.textColor = .black
        })
        
        for i in 2..<collectionLabel.count {
            collectionLabel[i].textAlignment = (i%2 != 0) ? .right : .left
            collectionLabel[i].textColor = (i%2 != 0) ? .gray : .label
        }
        
        collectionLabel[2].text = NSLocalizedString("about", comment: "")
        
        btnSeeMore.setTitle(NSLocalizedString("seemore", comment: ""), for: .normal)
        
        collectionLabel.first?.isHidden = true
        
        tvAbout.isEditable = false
        tvAbout.textColor = .gray
        tvAbout.font = UIFont.boldSystemFont(ofSize: 16)
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {

            switch swipeGesture.direction {
            case .right:
                self.dismissWith()
            default:
                break
            }
        }
    }

    @IBAction func didTapSeeMore(_ sender: UIButton) {
        url.openUrl()
    }
    
    private func setBroker() {
        imgIntitution.image = UIImage(data: Data(base64Encoded: broker.image ?? "")!)
        collectionLabel[1].text = broker.title
        tvAbout.text = broker.about?.addLineBreak()
        url = broker.url
    }
}


extension DetailDescriptionBrokersViewController: NavigationBarHeaderDelegate {
    func didTapButtonBack(_ sender: UIButton) {
        dismissWith()
    }
    
    
}
