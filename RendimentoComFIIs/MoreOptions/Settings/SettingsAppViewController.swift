//
//  SettingsAppViewController.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 30/11/22.
//

import UIKit

protocol SettingsAppDisplayLogic {
    func showMessage(_ msg: String, _ isSuccess: Bool)
}


class SettingsAppViewController: UIViewController, SettingsAppDisplayLogic {

    @IBOutlet weak var viewHeader: NavigationBarHeaderView!
    @IBOutlet var collectionLabel: [UILabel]!
    @IBOutlet var collectionRadio: [UIButton]!
    @IBOutlet weak var switchWalletPublic: UISwitch!
    @IBOutlet weak var btnSave: UIButton!
    
    var hasChanged = false
    
    var interactor: SettingsAppBusinessLogic?
    var router: (NSObjectProtocol & SettingsAppRoutingLogic & SettingsAppDataPassing)?
    
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
        let interactor = SettingsAppInteractor()
        let presenter = SettingsAppPresenter()
        let router = SettingsAppRouter()
        
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

        setupLayout()
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
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

    private func setupLayout() {
        viewHeader.setTitleHeader(name: NSLocalizedString("settings", comment: ""))
        viewHeader.delegate = self
        
        collectionLabel.forEach({
            $0.font = UIFont.boldSystemFont(ofSize: 18)
            $0.numberOfLines = 0
            $0.text = $0.isEqual(collectionLabel.first) ? NSLocalizedString("question_wallet_public", comment: "") : $0.text
            $0.text = $0.isEqual(collectionLabel[1]) ? NSLocalizedString("total_news_archive", comment: "") : $0.text
        })
        
        var value = 10
        collectionRadio.forEach({
            $0.setupDefault(35, "circle.circle", "  \(value)")
            value += 10
        })
        switch UserDefaultKeys.totalNewsInArchive.getValue() as! Int {
        case 10:
            didTapRadio(collectionRadio[0])
        case 30:
            didTapRadio(collectionRadio[2])
        default:
            didTapRadio(collectionRadio[1])
        }
        
        switchWalletPublic.isOn = UserDefaultKeys.wallet_public.getValue() as! Bool
        switchWalletPublic.isEnabled = false
        collectionLabel.first?.isEnabled = switchWalletPublic.isEnabled
        btnSave.isEnabled = switchWalletPublic.isEnabled
        
        btnSave.setTitle(NSLocalizedString("btn_save", comment: ""), for: .normal)
        
        isVip()
    }
    
    private func checkChanges() {
        hasChanged ? interactor?.saveSettings() : showMessage(NSLocalizedString("save_success", comment: ""), true)
        hasChanged ? UserDefaultKeys.wallet_public.setValue(value: switchWalletPublic.isOn) : nil
    }
    
    private func isVip() {
        if UserDefaultKeys.vip.getValue() as! Bool == false {
            collectionRadio.forEach({ $0.isEnabled = false })
            collectionLabel[1].isEnabled = false
            collectionLabel[1].text = "\(UserDefaultKeys.vip.getValue() as! Bool == false ? "(PRO)" : "")  \(collectionLabel[1].text!)"
        }
    }
    
    func showMessage(_ msg: String, _ isSuccess: Bool) {
        self.alertView(type: isSuccess ? .success : .error, message: msg).delegate = self
    }

    @IBAction func didTapSwitch(_ sender: UISwitch) {
        if sender.isEqual(switchWalletPublic), sender.isOn != UserDefaultKeys.wallet_public.getValue() as! Bool {
            hasChanged = true
        }
        
    }
    @IBAction func didTapSave(_ sender: Any) {
        checkChanges()
    }
    
    @IBAction func didTapRadio(_ sender: UIButton) {
        UserDefaultKeys.totalNewsInArchive.setValue(value: Int(sender.currentTitle?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "0")!)
        collectionRadio.forEach({
            $0 == sender ? $0.setImage(UIImage(systemName: "circle.circle.fill"), for: .normal) : $0.setImage(UIImage(systemName: "circle.circle"), for: .normal)
            $0.tintColor = $0 == sender ? UIColor().colorRadioActive : UIColor().colorRadioDisabled
        })
        
    }
}


extension SettingsAppViewController: NavigationBarHeaderDelegate {
    func didTapButtonBack(_ sender: UIButton) {
        dismissWith()
    }
    
}


extension SettingsAppViewController: ActionButtonAlertDelegate {
    func close() {
        dismiss(animated: true)
    }
}
