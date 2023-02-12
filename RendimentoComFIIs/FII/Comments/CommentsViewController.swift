//
//  CommentsViewController.swift
//  RendimentoComFII
//
//  Created by Israel Alves on 15/04/22.
//

import UIKit
import SwiftSoup
import Lottie

protocol CommentsDisplayLogic {
    func getCodeFii(_ code: String)
    func showSomething(_ listComments: [Comments])
}

class CommentsViewController: UIViewController, CommentsDisplayLogic {
    
    @IBOutlet weak var viewHeader: NavigationBarHeaderView!
    @IBOutlet weak var tableComments: UITableView!
    @IBOutlet weak var lbTitleCollection: UILabel!
    @IBOutlet weak var collectionSites: UICollectionView!
    
    var loading: LottieAnimationView?
    var codeFii = ""
    var newsUrl: String?
    var listComments = [Comments]()
    var listSites: [(String, String)]?
    
    var interactor: CommentsBusinessLogic?
    var router: (NSObjectProtocol & CommentsRoutingLogic & CommentsDataPassing)?
    
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
        let interactor = CommentsInteractor()
        let presenter = CommentsPresenter()
        let router = CommentsRouter()
        
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
        interactor?.getCodeFii()
        setupLayout()
        interactor?.doSomething()
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func setupLayout() {
        loading = view.loadingLottie("search_comments")
        self.view.backgroundColor = .systemGray6
        
        viewHeader.delegate = self
        viewHeader.setTitleHeader(name: NSLocalizedString("comments", comment: ""))
        
        tableComments.backgroundColor = .clear
        tableComments.delegate = self
        tableComments.dataSource = self
        
        lbTitleCollection.text = NSLocalizedString("see_more", comment: "")
        lbTitleCollection.font = UIFont.boldSystemFont(ofSize: 16)
        
        collectionSites.backgroundColor = .clear
        collectionSites.delegate = self
        collectionSites.dataSource = self
        
        listSites = [(url: "https://www.clubefii.com.br/fiis/\(codeFii)#comentarios", nameImg: "clubefii"),
                     (url: "https://www.fundsexplorer.com.br/funds/\(codeFii)", nameImg: "fundsexplorercolor"),
                     (url: "https://www.guiainvest.com.br/h/\(codeFii)?sigla=\(codeFii)", nameImg: "guiainvest")
        ]
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
    
    func getCodeFii(_ code: String) {
        self.codeFii = code
    }
    
    func showSomething(_ list: [Comments]) {
        DispatchQueue.main.async {
            if list.count > 0 {
                var listTemp = list
                for _ in 0..<(listTemp.count >= 5 ? 5 : listTemp.count) {
                    self.listComments.append(listTemp.remove(at: Int(arc4random_uniform(UInt32(listTemp.count)))))
                }
                self.loading?.removeFromSuperview()
            } else {
                self.listComments.append(.init(author: "", comments: NSLocalizedString("no_comments", comment: ""), date: "", site: ""))
                self.loading?.removeFromSuperview()
            }
            self.tableComments.reloadData()
        }
        
    }
    
}


extension CommentsViewController: NavigationBarHeaderDelegate {
    func didTapButtonBack(_ sender: UIButton) {
        dismissWith()
    }
}


extension CommentsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listComments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellComments", for: indexPath) as? CommentsTableViewCell
        cell?.setData(listComments[indexPath.row])
        
        return cell!
    }
    
    
}


extension CommentsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        newsUrl = listSites?[2].0
        if UserDefaults.standard.bool(forKey: UserDefaultKeys.hideNewsAlert.rawValue) {
            newsUrl?.openUrl()
        } else {
            alertView(type: .info, message: NSLocalizedString("do_comment", comment: "")).delegate = self
        }
    }
}


extension CommentsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listSites?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellSites", for: indexPath) as? CommentsSitesCollectionViewCell
        cell?.setImage(from: listSites?[indexPath.row].1 ?? "")
        return cell!
    }
    
    
}

extension CommentsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 60)
    }
}


extension CommentsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        newsUrl = listSites?[indexPath.row].0
        if UserDefaults.standard.bool(forKey: UserDefaultKeys.hideNewsAlert.rawValue) {
            newsUrl?.openUrl()
        } else {
            alertView(type: .info, message: NSLocalizedString("do_comment", comment: "")).delegate = self
        }
    }
}


extension CommentsViewController: ActionButtonAlertDelegate {
    func close() {
        dismiss(animated: false) {
            Util.hideAlertMessage()
            self.newsUrl?.openUrl()
        }
    }
}
