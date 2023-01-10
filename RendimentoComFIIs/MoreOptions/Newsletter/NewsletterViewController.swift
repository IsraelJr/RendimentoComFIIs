//
//  ViewController.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

protocol NewsletterDisplayLogic {
    
}


class NewsletterViewController: UIViewController, NewsletterDisplayLogic {
    
    @IBOutlet weak var viewHeader: NavigationBarHeaderView!
    @IBOutlet weak var tableNews: UITableView!
    
    var listNewsletter = NewsletterModel.listAllNews
    var url = ""
    var interactor: NewsletterBusinessLogic?
    var router: (NSObjectProtocol & NewsletterRoutingLogic & NewsletterDataPassing)?
    
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
        let interactor = NewsletterInteractor()
        let presenter = NewsletterPresenter()
        let router = NewsletterRouter()
        
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
    
    private func setupLayout() {
        viewHeader.delegate = self
        viewHeader.setTitleHeader(name: NSLocalizedString("title_newsletter", comment: ""))
        
        tableNews.delegate = self
        tableNews.dataSource = self
        tableNews == nil ? nil : tableNews.reloadData()
        
        let days = UserDefaultKeys.vip.getValue() as! Bool ? UserDefaultKeys.totalNewsInArchive.getValue() as! Int : 3
        listNewsletter.removeAll(where: { Calendar.current.dateComponents([.day], from: $0.date?.toDate() ?? Date(), to: Date()).day! > days } )
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


extension NewsletterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listNewsletter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! NewsTableViewCell
        cell.setData(obj: (listNewsletter[indexPath.row]))
        
        return cell
    }
    
    
}


extension NewsletterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        url = listNewsletter[indexPath.row].href ?? ""
        if UserDefaults.standard.bool(forKey: UserDefaultKeys.hideNewsAlert.rawValue) {
            url.openUrl()
        } else {
            alertView(type: .info, message: NSLocalizedString("do_comment", comment: "")).delegate = self
        }
    }
}


extension NewsletterViewController: NavigationBarHeaderDelegate {
    func didTapButtonBack(_ sender: UIButton) {
        dismissWith()
    }
}


extension NewsletterViewController: ActionButtonAlertDelegate {
    func close() {
        dismiss(animated: false) {
            Util.hideAlertMessage()
            self.url.openUrl()
        }
    }
}
