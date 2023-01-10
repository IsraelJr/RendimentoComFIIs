//
//  DetailDescriptionBooksViewController.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 02/05/22.
//

import UIKit

class DetailDescriptionBooksViewController: UIViewController {
    
    @IBOutlet weak var viewHeader: NavigationBarHeaderView!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet var collectionLabel: [UILabel]!
    @IBOutlet weak var tvAbout: UITextView!
    
    var book = DetailModel.FetchBooks.Books.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setBook()
        
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
        viewHeader.setTitleHeader(name: NSLocalizedString("books", comment: ""))
        viewHeader.delegate = self
        
        viewMain.layer.cornerRadius = 16
        
        img.layer.cornerRadius = 8
        img.contentMode = .scaleAspectFill
        
        for i in 0..<collectionLabel.count {
            collectionLabel[i].font = i == 0 ? UIFont.boldSystemFont(ofSize: 24) : UIFont.boldSystemFont(ofSize: 16)
            collectionLabel[i].numberOfLines = i == 0 ? 6 : 1
            collectionLabel[i].adjustsFontSizeToFitWidth = true
            collectionLabel[i].minimumScaleFactor = 0.1
            collectionLabel[i].textColor = i%2 == 0 ? .gray : .label
            collectionLabel[i].textAlignment = (i%2 == 0) && i > 0 ? .right : .left
        }
        collectionLabel[1].text = NSLocalizedString("ISBN13", comment: "")
        collectionLabel[3].text = NSLocalizedString("author", comment: "")
        collectionLabel[5].text = NSLocalizedString("pages", comment: "")
        collectionLabel[7].text = NSLocalizedString("language", comment: "")
        collectionLabel.last?.text = NSLocalizedString("about", comment: "")
        
        tvAbout.isEditable = false
        tvAbout.textColor = collectionLabel.first?.textColor
        tvAbout.font = collectionLabel.last?.font
    }
    
    private func setBook() {
        img.image = UIImage(data: Data(base64Encoded: book.image)!)
        collectionLabel.first?.text = book.title
        collectionLabel[2].text = book.isbn13
        collectionLabel[4].text = book.author
        collectionLabel[6].text = book.pages
        collectionLabel[8].text = book.language
        tvAbout.text = book.about.addLineBreak()
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
}


extension DetailDescriptionBooksViewController: NavigationBarHeaderDelegate {
    func didTapButtonBack(_ sender: UIButton) {
        dismissWith()
    }
    
    
}
