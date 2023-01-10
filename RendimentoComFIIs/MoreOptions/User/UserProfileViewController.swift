//
//  ViewController.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

protocol UserProfileDisplayLogic {
    func deletedWallet(_ deleted: Bool)
    func deletedAccount(_ deleted: Bool)
}


class UserProfileViewController: UIViewController, UserProfileDisplayLogic {
    
    @IBOutlet weak var viewHeader: NavigationBarHeaderView!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet var collectionView: [UIView]!
    @IBOutlet var collectionTextField: [UITextField]!
    @IBOutlet var collectionButton: [UIButton]!
    @IBOutlet var collectionRadio: [UIButton]!
    @IBOutlet weak var viewInbox: UIView!
    @IBOutlet weak var lbTitleInbox: UILabel!
    @IBOutlet weak var btnMessage: UIButton!
    
    var action: UIButton?
    var deleted = false
    var gender: String?
    
    var interactor: UserProfileBusinessLogic?
    var router: (NSObjectProtocol & UserProfileRoutingLogic & UserProfileDataPassing)?
    
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
        let interactor = UserProfileInteractor()
        let presenter = UserProfilePresenter()
        let router = UserProfileRouter()
        
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
        setupLayout()
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let value = gender, !(DataUser.gender?.elementsEqual(value) ?? false) else { return }
        DataUser.gender = value
        interactor?.updateAccount()
    }
    
    private func setupLayout() {
        viewHeader.delegate = self
        viewHeader.setTitleHeader(name: NSLocalizedString("title_user_profile", comment: ""))
        
        viewMain.backgroundColor = UIColor(named: "Border")
        viewMain.layer.cornerRadius = 40
        
        collectionView.forEach({
            $0.backgroundColor = .systemBackground
            $0.layer.borderWidth = 2
            $0.layer.borderColor = UIColor.clear.cgColor
            $0.layer.cornerRadius = $0 == collectionView.first ? $0.frame.height/2 : collectionView.first!.layer.cornerRadius
        })
        
        collectionTextField.forEach({
            $0.backgroundColor = .clear
            $0.borderStyle = .none
            $0.font = UIFont.boldSystemFont(ofSize: 16)
            $0.text = $0 == collectionTextField.first ? DataUser.name ?? "" : DataUser.email ?? ""
            $0.isEnabled = false
            $0.textColor = .placeholderText
        })
        
        collectionButton.forEach({
            $0.backgroundColor = .clear
            $0.setTitleColor(UIColor(named: "Font"), for: .normal)
            $0.setTitle($0 == collectionButton.first ? NSLocalizedString("clean_wallet", comment: "") : NSLocalizedString("delete_account", comment: ""), for: .normal)
        })
        
        collectionRadio.forEach({
            $0 == collectionRadio.first ? $0.setupDefault(35, "circle.circle", " \(NSLocalizedString("gender_male", comment: ""))") : $0.setupDefault(35, "circle.circle", " \(NSLocalizedString("gender_female", comment: ""))")
            $0 == collectionRadio.last ? $0.setupDefault(35, "circle.circle", " \(NSLocalizedString("other", comment: ""))") : nil
            $0.tintColor = UIColor().colorRadioDisabled
            $0.currentTitle?.trimmingCharacters(in: .whitespacesAndNewlines).prefix(1).lowercased() == DataUser.gender?.prefix(1).lowercased() ?? "" ? didTapRadio($0) : nil
            
        })
        
        viewInbox.backgroundColor = UIColor(named: "Border")
        viewInbox.layer.cornerRadius = 16
        
        lbTitleInbox.font = UIFont.boldSystemFont(ofSize: 16)
        lbTitleInbox.textColor = .systemBackground
        lbTitleInbox.text = NSLocalizedString("inbox", comment: "")
        
        btnMessage.setupDefault(35, "arrow.forward")
        btnMessage.tintColor = .systemBackground
        
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
    
    func deletedWallet(_ deleted: Bool) {
        if deleted {
            self.alertView(type: .success, message: NSLocalizedString("clean_success", comment: "")).delegate = self
        } else {
            self.alertView(type: .error, message: NSLocalizedString("clean_error", comment: "")).delegate = self
        }
    }
    
    func deletedAccount(_ deleted: Bool) {
        if deleted {
            self.alertView(type: .success, message: NSLocalizedString("delete_success", comment: "")).delegate = self
            self.deleted = true
        } else {
            self.alertView(type: .error, message: NSLocalizedString("delete_error", comment: "")).delegate = self
        }
    }
    
    @IBAction func didTapBtnUserProfile(_ sender: UIButton) {
        action = sender
        switch sender {
        case collectionButton.first:
            let alert = alertView(type: .warning, message: NSLocalizedString("clean_desc", comment: ""))
            alert.setupBtnYes(titleYes: NSLocalizedString("clean_yes", comment: ""), titleNo: NSLocalizedString("clean_no", comment: ""))
            alert.delegate = self
            
        default:
            let alert = alertView(type: .warning, message: NSLocalizedString("delete_desc", comment: ""))
            alert.setupBtnYes(titleYes: NSLocalizedString("delete_yes", comment: ""), titleNo: NSLocalizedString("delete_no", comment: ""))
            alert.delegate = self
        }
    }
 
    @IBAction func didTapRadio(_ sender: UIButton) {
        collectionRadio.forEach({
            $0 == sender ? $0.setImage(UIImage(systemName: "circle.circle.fill"), for: .normal) : $0.setImage(UIImage(systemName: "circle.circle"), for: .normal)
            $0.tintColor = $0 == sender ? UIColor().colorRadioActive : UIColor().colorRadioDisabled
        })
        switch sender {
        case collectionRadio.first:
            gender = MoreOptions.male.rawValue
        case collectionRadio.last:
            gender = "other"
        default:
            gender = MoreOptions.female.rawValue
        }

    }
    
    @IBAction func showInbox(_ sender: UIButton) {
        segueTo(destination: storyboard?.instantiateViewController(withIdentifier: "inbox") as! UserInboxViewController)
    }
}


extension UserProfileViewController: NavigationBarHeaderDelegate {
    func didTapButtonBack(_ sender: UIButton) {
        dismissWith()
    }
}


extension UserProfileViewController: ActionButtonAlertDelegate {
    func close() {
        dismiss(animated: true) {
            if self.deleted {
                UserDefaults.resetStandardUserDefaults()
                Util.exit()
            }
        }
    }
    
    func yes() {
        switch action {
        case collectionButton.first:
            dismiss(animated: true) {
                self.interactor?.deleteWallet()
            }
        case collectionButton.last:
            dismiss(animated: true) {
                self.interactor?.deleteAccount()
            }
        default:
            dismiss(animated: true)
        }
    }
    
}
