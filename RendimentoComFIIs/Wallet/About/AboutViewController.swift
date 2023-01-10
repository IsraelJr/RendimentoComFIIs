//
//  ViewController.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

protocol AboutDisplayLogic {
    //    func showData()
}


class AboutViewController: UIViewController, AboutDisplayLogic {
    
    @IBOutlet weak var viewHeader: NavigationBarHeaderView!
    @IBOutlet weak var collectionAboutWallet: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    let list = [
        AboutWallet(image: UIImage(named: "about_first"), title: NSLocalizedString("about_first_title", comment: ""), description: NSLocalizedString("about_first_description", comment: ""))
        ,AboutWallet(image: UIImage(named: "add"), title: NSLocalizedString("about_add_title", comment: ""), description: NSLocalizedString("about_add_description", comment: ""))
        ,AboutWallet(image: UIImage(named: "delete"), title: NSLocalizedString("about_delete_title", comment: ""), description: NSLocalizedString("about_delete_description", comment: ""))
        ,AboutWallet(image: UIImage(named: "about_last"), title: NSLocalizedString("about_last_title", comment: ""), description: NSLocalizedString("about_last_description", comment: ""))
    ]
    
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
        //        let interactor = AboutInteractor()
        //        let presenter = AboutPresenter()
        //        let router = AboutRouter()
        //
        //        self.interactor = interactor
        //        self.router = router
        //        interactor.presenter = presenter
        //        presenter.viewController = self
        //        router.viewController = self
        //        router.dataStore = interactor
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
        //        showData()
        
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
        viewHeader.setTitleHeader(name: NSLocalizedString("wallet", comment: ""))
        viewHeader.delegate = self
        
        collectionAboutWallet.delegate = self
        collectionAboutWallet.dataSource = self
        collectionAboutWallet.backgroundColor = .clear
        
        pageControl.isUserInteractionEnabled = false
        pageControl.numberOfPages = list.count
        pageControl.currentPageIndicatorTintColor = UIColor(named: "Font")
        pageControl.pageIndicatorTintColor = .systemGray5
    
    }
    
    func showData() {}
    
}

extension AboutViewController: NavigationBarHeaderDelegate {
    func didTapButtonBack(_ sender: UIButton) {
        dismissWith()
    }
}


extension AboutViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! AboutCollectionViewCell
        cell.setData(list[indexPath.row])
        
        return cell
    }
    
    
}


extension AboutViewController: UICollectionViewDelegate {
    
}



extension AboutViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}


extension AboutViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
    
}
