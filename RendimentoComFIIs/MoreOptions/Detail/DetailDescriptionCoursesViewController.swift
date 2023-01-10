//
//  DetailDescriptionCoursesViewController.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 02/05/22.
//

import UIKit

class DetailDescriptionCoursesViewController: UIViewController {
    
    @IBOutlet weak var viewHeader: NavigationBarHeaderView!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var imgIntitution: UIImageView!
    @IBOutlet var collectionLabel: [UILabel]!
    @IBOutlet weak var btnSeeMore: UIButton!
    @IBOutlet weak var tvAbout: UITextView!
    
    var course = DetailModel.FetchCourses.Courses.init()
    var url = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setCourse()
        
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
        viewHeader.setTitleHeader(name: NSLocalizedString("courses", comment: ""))
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
        
        collectionLabel[2].text = NSLocalizedString("modality", comment: "")
        collectionLabel[4].text = NSLocalizedString("workload", comment: "")
        collectionLabel[6].text = NSLocalizedString("course_is", comment: "")
        collectionLabel[8].text = NSLocalizedString("about", comment: "")
        
        btnSeeMore.setTitle(NSLocalizedString("seemore", comment: ""), for: .normal)
        
        collectionLabel.first?.isHidden = true
        
        tvAbout.isEditable = false
        tvAbout.textColor = collectionLabel[3].textColor
        tvAbout.font = collectionLabel[3].font
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
    
    private func setCourse() {
        imgIntitution.image = UIImage(data: Data(base64Encoded: course.img ?? "")!)
        collectionLabel[0].text = course.institution
        collectionLabel[1].text = course.title
        collectionLabel[3].text = NSLocalizedString(course.modality.rawValue, comment: "")
        collectionLabel[5].text = course.workload
        collectionLabel[7].text = course.isFree ? NSLocalizedString("free", comment: "") : NSLocalizedString("paid", comment: "")
        tvAbout.text = course.about?.addLineBreak()
        url = course.url
    }
}


extension DetailDescriptionCoursesViewController: NavigationBarHeaderDelegate {
    func didTapButtonBack(_ sender: UIButton) {
        dismissWith()
    }
    
    
}
