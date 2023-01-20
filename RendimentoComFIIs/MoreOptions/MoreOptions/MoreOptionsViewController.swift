//
//  MoreOptionsViewController.swift
//  RendimentoComFII
//
//  Created by Israel Alves on 05/04/22.
//

import UIKit

//struct CustomNavigationItem {
//    static var idNavigation: Int = 0
//}
//
//protocol ActionButtonNavigationProtocol {
//    func didTapButtons(_ sender: UIButton)
//}

protocol MoreOptionsDisplayLogic {
    func showSomething(_ object: MoreOptionsModel.Fetch.MoreOptions)
}

class MoreOptionsViewController: UIViewController, MoreOptionsDisplayLogic {
    
    @IBOutlet weak var viewHeader: NavigationBarHeaderView!
    @IBOutlet weak var stackViewPro: UIStackView!
    @IBOutlet weak var viewPro: UIView!
    //    @IBOutlet weak var lbSubTitlePro: UILabel!
    @IBOutlet var collectionLabel: [UILabel]!
    @IBOutlet weak var btnPro: UIButton!
    @IBOutlet weak var viewWalletPublic: UIView!
    @IBOutlet weak var btnWalletPublic: UIButton!
    @IBOutlet weak var collectionOptions: UICollectionView!
    
    var arrayCell = [String]()
    
    var nav: NavigationBarFooterView!
    
    var interactor: MoreOptionsBusinessLogic?
    var router: (NSObjectProtocol & MoreOptionsRoutingLogic & MoreOptionsDataPassing)?
    
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
        let interactor = MoreOptionsInteractor()
        let presenter = MoreOptionsPresenter()
        let router = MoreOptionsRouter()
        
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
    }
    
    private func setupLayout() {
        viewHeader.setTitleHeader(name: NSLocalizedString("explore", comment: ""))
        viewHeader.btnReturn.isHidden = true
        
        collectionOptions.delegate = self
        collectionOptions.dataSource = self
        collectionOptions.backgroundColor = .clear
        
        nav = view.createNavigationBarFooter(position: 3)
        nav.delegate = self
        
        viewPro.layer.cornerRadius = 16
        viewPro.backgroundColor = UIColor(named: "Font")
        
        viewWalletPublic.layer.cornerRadius = viewPro.layer.cornerRadius
        viewWalletPublic.backgroundColor = viewPro.backgroundColor
        
        if let vip = DataUser.vip, vip < -2 {
            viewPro.removeFromSuperview()
        }
        
        collectionLabel.forEach {
            $0.font = UIFont.boldSystemFont(ofSize: 25)
            $0.text = $0.isEqual(collectionLabel.first) ? InitializationModel.systemName : NSLocalizedString("public_wallet", comment: "")
            $0.numberOfLines = 2
            $0.textAlignment = .center
            $0.adjustsFontSizeToFitWidth = true
            $0.minimumScaleFactor = 0.1
            $0.textColor = .white
            $0.textAlignment = .left
            
        }
        
        btnPro.setupDefault(45, "", NSLocalizedString("bePro", comment: ""))
        btnPro.tintColor = .white
        
        btnWalletPublic.setupDefault(35, "arrow.forward.circle.fill")
        btnWalletPublic.tintColor = .white
        
        for value in MoreOptions.allCases {
            if !value.rawValue.elementsEqual(MoreOptions.exit.rawValue), !value.rawValue.elementsEqual(MoreOptions.male.rawValue), !value.rawValue.elementsEqual(MoreOptions.female.rawValue), !value.rawValue.elementsEqual(MoreOptions.neutral.rawValue) {
                arrayCell.append(value.rawValue)
            }
        }
        arrayCell.append(MoreOptions(rawValue: DataUser.gender ?? "")?.rawValue ?? MoreOptions.neutral.rawValue)
        arrayCell.append(MoreOptions.exit.rawValue)
    }
    
    func showSomething(_ object: MoreOptionsModel.Fetch.MoreOptions) {
        
    }
    
    @IBAction func didTapButtons(_ sender: UIButton) {
        if sender.isEqual(btnWalletPublic) {
            let vc = storyboard?.instantiateViewController(withIdentifier: "listWP") as! ListWalletPublicViewController
            segueTo(destination: vc)
        }
    }
}


extension MoreOptionsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayCell.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MoreOptionsCollectionViewCell
        cell.setData(from: arrayCell[indexPath.row])
        
        return cell
    }
    
}


extension MoreOptionsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 130, height: 130)
    }
}



extension MoreOptionsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) { }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == arrayCell.count-1 {
            let alert = alertView(type: .info, message: NSLocalizedString("logout_question", comment: ""))
            alert.setupBtnYes(titleYes: NSLocalizedString("logout_yes", comment: ""))
            alert.delegate = self
        }
        
        let option = MoreOptions(rawValue: NSLocalizedString((collectionView.cellForItem(at: indexPath) as! MoreOptionsCollectionViewCell).title.text!, comment: ""))
        switch option {
        case .aboutfii, .library:
            interactor?.passToMenu(to: option!)
            router?.routeTosegueDetailWithSegue(segue: nil)
            
        case .archive:
            router?.routeToViewController(to: .Newsletter)
            
        case .aboutapp:
            router?.routeToViewController(to: .AboutApp)
            
        case .contactus:
            router?.routeToViewController(to: .ContactUs)
            
        case .male, .female, .neutral:
            router?.routeToViewController(to: .UserProfile)
            
        case .settings:
            router?.routeToViewController(to: .SettingsApp)
            
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) { }
}



extension MoreOptionsViewController: NavigationBarFooterDelegate {
    func didTapButtonNavigation(_ sender: UIButton) {
        var vc: UIViewController!
        switch sender.tag {
        case 0:
            vc = storyboard?.instantiateViewController(withIdentifier: "home") as! HomeViewController
            present(vc, animated: false)
            
        case 1:
            vc = storyboard?.instantiateViewController(withIdentifier: "wallet") as! WalletViewController
            present(vc, animated: false)
            
        case 2:
            vc = storyboard?.instantiateViewController(withIdentifier: "search") as! SearchViewController
            present(vc, animated: false)
            
        default:
            break
        }
    }
}


extension MoreOptionsViewController: ActionButtonAlertDelegate {
    func close() {
        dismiss(animated: true)
    }
    
    func yes() {
        Util.exit()
    }
}
