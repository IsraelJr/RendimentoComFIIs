//
//  ViewController.swift
//  RendimentoComFII
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

protocol SearchDisplayLogic {
    
}


class SearchViewController: UIViewController, SearchDisplayLogic {
    
    @IBOutlet weak var viewHeader: NavigationBarHeaderView!
    @IBOutlet weak var viewSegments: UIView!
    @IBOutlet var collectionButtonSegment: [UIButton]!
    @IBOutlet weak var collectionCategory: UICollectionView!
    @IBOutlet weak var collectionSearchFii: UICollectionView!
    @IBOutlet weak var lbTitleCollectionSearch: UILabel!
    @IBOutlet weak var search: UISearchBar!
    
    var allFiis = ListFii.allFiis()
    
    var interactor: SearchBusinessLogic?
    var router: (NSObjectProtocol & SearchRoutingLogic & SearchDataPassing)?
    
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
        let interactor = SearchInteractor()
        let presenter = SearchPresenter()
        let router = SearchRouter()
        
        self.interactor = interactor
        self.router = router
        interactor.presenter = presenter
        presenter.viewController = self
        router.viewController = self
        router.dataStore = interactor
    }
    
    // MARK: Routing
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupLayout()
    }
    
    private func setupLayout() {
        
        viewHeader.setTitleHeader(name: NSLocalizedString("search", comment: ""))
        viewHeader.btnReturn.isHidden = true
        
        let viewFooter = view.createNavigationBarFooter(position: 2)
        viewFooter.delegate = self
        
        collectionCategory.backgroundColor = .clear
        collectionCategory.delegate = self
        collectionCategory.dataSource = self
        
        collectionSearchFii.backgroundColor = .clear
        collectionSearchFii.delegate = self
        collectionSearchFii.dataSource = self
        
        search.delegate = self
        search.searchBarStyle = .minimal
        search.searchTextField.placeholder = "FII"
        search.searchTextField.delegate = self
        search.searchTextField.keyboardType = .alphabet
        search.searchTextField.returnKeyType = .done
        search.searchTextField.font = UIFont.boldSystemFont(ofSize: 16)
        
        lbTitleCollectionSearch.font = UIFont.boldSystemFont(ofSize: 24)
        lbTitleCollectionSearch.textAlignment = .center
        lbTitleCollectionSearch.numberOfLines = 1
        lbTitleCollectionSearch.adjustsFontSizeToFitWidth = true
        lbTitleCollectionSearch.minimumScaleFactor = 0.5
        lbTitleCollectionSearch.text = "FIIs"
        
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
    
    
    private func setFii(_ fii: FIIModel.Fetch.FII) {
        interactor?.setFii(fii)
        router?.routeTosegueFIIWithSegue(segue: nil)
    }
    
    private func reloadFIIs(_ text: String) {
        allFiis = ListFii.sortByLetters(text: text)
        collectionSearchFii.reloadData()
    }
    
    private func filterSegment(_ title: String) {
        let segment = FiiSegment(rawValue: NSLocalizedString(title.trimmingCharacters(in: .whitespacesAndNewlines), comment: ""))
        lbTitleCollectionSearch.text = segment == FiiSegment.all ? "FIIs" : "FIIs: \(title)"
        allFiis = ListFii.sortBySegment(segment: segment!)
        collectionSearchFii.reloadData()
        _ = textFieldShouldReturn(search.searchTextField)
    }
    
}


extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.isEqual(collectionSearchFii) {
            if allFiis.count > 0 {
                DispatchQueue.main.async {
                    collectionView.scrollToItem(at: IndexPath (item: 0, section: 0), at: .bottom, animated: true)
                }
            }
            return allFiis.count
        }
        
        return FiiSegment.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.isEqual(collectionSearchFii) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SearchCollectionViewCell
            cell.setData(from: allFiis[indexPath.row].code)
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellCat", for: indexPath) as! SearchCategoryCollectionViewCell
        cell.setData(from: FiiSegment.allCases[indexPath.row])
        return cell
        
    }
    
}


extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView.isEqual(collectionSearchFii) {
            return 30
        }
        
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView.isEqual(collectionSearchFii) {
            return UIScreen.main.bounds.width < 390 ? 30 : 15
        }
        
        return 5
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.isEqual(collectionSearchFii) {
            let size =  UIScreen.main.bounds.width < 390 ? 130 : 100
            return CGSize(width: size, height: size)
        }
        
        return CGSize(width: FiiSegment.allCases[indexPath.row].description().size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17)]).width, height: 32)
    }
    
}



extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) { }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.isEqual(collectionSearchFii) {
            setFii(FIIModel.Fetch.FII.init(socialReason: "", name: nil, code: allFiis[indexPath.row].code, segment: nil, price: nil, earnings: nil))
        } else {
            search.text?.removeAll()
            filterSegment((collectionView.cellForItem(at: indexPath) as! SearchCategoryCollectionViewCell).title.text ?? FiiSegment.all.description())
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) { }
}



extension SearchViewController: NavigationBarFooterDelegate {
    func didTapButtonNavigation(_ sender: UIButton) {
        var vc: UIViewController!
        switch sender.tag {
        case 0:
            vc = storyboard?.instantiateViewController(withIdentifier: "home") as! HomeViewController
            present(vc, animated: false)
            
        case 1:
            vc = storyboard?.instantiateViewController(withIdentifier: "wallet") as! WalletViewController
            present(vc, animated: false)
            
        case 3:
            vc = storyboard?.instantiateViewController(withIdentifier: "moreOptions") as! MoreOptionsViewController
            present(vc, animated: false)
            
        default:
            break
        }
    }
}


extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = searchBar.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        
        if let char = text.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if (isBackSpace == -92) {
                if updatedText.isEmpty {
                    filterSegment(FiiSegment.all.description())
                    searchBar.searchTextField.text?.removeAll()
                } else {
                    reloadFIIs(updatedText)
                    return false
                }
                return true
            }
        }
        if !updatedText.isEmpty, updatedText.count <= 7 {
            searchBar.searchTextField.textColor = UIColor.darkGray
            searchBar.text = updatedText.uppercased()
            reloadFIIs(searchBar.text ?? "")
        }
        return false
    }
    
}


extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        filterSegment(FiiSegment.all.description())
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
