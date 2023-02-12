//
//  ViewController.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

protocol ListWalletPublicDisplayLogic {
    func showWalletPublic(_ list: [ListWalletPublicModel.Fetch.ListWalletPublic])
}


class ListWalletPublicViewController: UIViewController, ListWalletPublicDisplayLogic {
    
    @IBOutlet weak var viewHeader: NavigationBarHeaderView!
    @IBOutlet weak var segmentOptions: UISegmentedControl!
    @IBOutlet weak var collectionOptions: UICollectionView!
    
    var listOptions, temp: [ListWalletPublicModel.Fetch.ListWalletPublic]?
    
    var interactor: ListWalletPublicBusinessLogic?
    var router: (NSObjectProtocol & ListWalletPublicRoutingLogic & ListWalletPublicDataPassing)?
    
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
        let interactor = ListWalletPublicInteractor()
        let presenter = ListWalletPublicPresenter()
        let router = ListWalletPublicRouter()
        
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
        interactor?.readWalletPublic()
        
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
        viewHeader.setTitleHeader(name: NSLocalizedString("public_wallet", comment: ""))
        viewHeader.delegate = self
        
        segmentOptions.customizeAppearance(quantidadeItems: 3)
        segmentOptions.setTitleList(
            [
                WalletRating.conservative.rawValue
                ,WalletRating.moderate.rawValue
                ,WalletRating.aggressive.rawValue
            ]
        )
        
        collectionOptions.delegate = self
        collectionOptions.dataSource = self
        collectionOptions.backgroundColor = .clear
    }
    
    private func sendData(_ index: Int) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "preview") as! PreviewViewController
        vc.dataPublicWallet.self = (owner: temp?[index].id ?? "", rating: temp?[index].rating.description() ?? "", description: temp?[index].description ?? "")
        var tempList = [(String,String)]()
        temp![index].fiis.forEach({ tempList.append(($0.key, $0.value)) })
        vc.valuesFiis = tempList
        tempList = [(String,String)]()
        temp![index].segments.forEach({ tempList.append(($0.key, $0.value)) })
        vc.valuesSegment = tempList
        present(vc, animated: true)
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
    
    @IBAction func didTapSegment(_ sender: UISegmentedControl) {
        temp = listOptions?.filter( { $0.rating.rawValue.elementsEqual(WalletRating.allCases[segmentOptions.selectedSegmentIndex].rawValue) } )
        collectionOptions.reloadData()
    }
    
    
    func showWalletPublic(_ list: [ListWalletPublicModel.Fetch.ListWalletPublic]) {
        listOptions = list
        didTapSegment(segmentOptions)
    }
    
}


extension ListWalletPublicViewController: NavigationBarHeaderDelegate {
    func didTapButtonBack(_ sender: UIButton) {
        dismissWith()
    }
}


extension ListWalletPublicViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return temp?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ListWalletPublicCollectionViewCell
        
        let s = temp?[indexPath.row].segments.sorted(by: { Double($0.value.replacingOccurrences(of: ",", with: ".").replacingOccurrences(of: "%", with: ""))! > Double($1.value.replacingOccurrences(of: ",", with: ".").replacingOccurrences(of: "%", with: ""))! }).first
        
        let f = temp?[indexPath.row].fiis.sorted(by: { Double($0.value.replacingOccurrences(of: ",", with: ".").replacingOccurrences(of: "%", with: ""))! > Double($1.value.replacingOccurrences(of: ",", with: ".").replacingOccurrences(of: "%", with: ""))! }).first
        
        cell.setData((fii: s?.key ?? "", segment: f?.key ?? ""))
        return cell
    }
    
    
}


extension ListWalletPublicViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ListWalletPublicCollectionViewCell
        cell.collectionLabel.forEach( {$0.textColor = UIColor(cgColor: WalletRating.allCases[segmentOptions.selectedSegmentIndex].getColor())} )
        cell.viewMain.layer.borderColor = WalletRating.allCases[segmentOptions.selectedSegmentIndex].getColor()
        sendData(indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ListWalletPublicCollectionViewCell
        cell.collectionLabel.forEach( {$0.textColor = .lightGray} )
        cell.viewMain.layer.borderColor = UIColor.clear.cgColor
    }
    
}
