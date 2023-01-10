//
//  ViewController.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

protocol AboutAppDisplayLogic {
    func setAbout(_ desc: String)
}

class AboutAppViewController: UIViewController, AboutAppDisplayLogic {
    
    @IBOutlet weak var viewHeader: NavigationBarHeaderView!
    @IBOutlet weak var lbDescription: UILabel!
    @IBOutlet weak var lbVersion: UILabel!
    @IBOutlet weak var btnTerms: UIButton!
    
    var interactor: AboutAppBusinessLogic?
    var router: (NSObjectProtocol & AboutAppRoutingLogic & AboutAppDataPassing)?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let interactor = AboutAppInteractor()
        let presenter = AboutAppPresenter()
        let router = AboutAppRouter()
        
        self.interactor = interactor
        self.router = router
        interactor.presenter = presenter
        presenter.viewController = self
        router.viewController = self
        router.dataStore = interactor
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //        if let scene = segue.identifier {
        //            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
        //            if let router = router, router.responds(to: selector) {
        //                router.perform(selector, with: segue)
        //            }
        //        }
        //        router?.routeTosegueHomeWithSegue(segue: segue)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        interactor?.getAboutApp()
        setupLayout()
        
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
        viewHeader.delegate = self
        viewHeader.setTitleHeader(name: NSLocalizedString("aboutapp", comment: ""))
        
        lbDescription.text?.removeAll()
        lbDescription.textColor = .gray
        lbDescription.font = UIFont.boldSystemFont(ofSize: 18)
        lbDescription.numberOfLines = 30
        lbDescription.lineBreakMode = .byWordWrapping
        lbDescription.adjustsFontSizeToFitWidth = true
        lbDescription.minimumScaleFactor = 0.1
        
        lbVersion.textColor = lbDescription.textColor
        lbVersion.textAlignment = .center
        lbVersion.font = UIFont.boldSystemFont(ofSize: 14)
        lbVersion.text = "\(NSLocalizedString("version", comment: "")) \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String)"
        
        btnTerms.setTitle(NSLocalizedString("terms_title", comment: ""), for: .normal)
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
    
    func setAbout(_ desc: String) {
        DispatchQueue.main.async {
            self.lbDescription.text = desc.addLineBreak()
        }
    }
    
    @IBAction func didTapTerms(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "terms") as! TermsViewController
        segueTo(destination: vc)
    }
    
}


extension AboutAppViewController: NavigationBarHeaderDelegate {
    func didTapButtonBack(_ sender: UIButton) {
        dismissWith()
    }
    
    
}
