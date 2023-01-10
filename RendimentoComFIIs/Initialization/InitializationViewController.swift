//
//  ViewController.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

protocol InitializationDisplayLogic {
    func flagNewOrUpdatedItem(_ list: [(ItemsLibrary, Bool)])
    func callHomeViewController()
}


class InitializationViewController: UIViewController, InitializationDisplayLogic {
    
    static var showOpenAd = true
    
    var loading: UIView?
    
    var interactor: InitializationBusinessLogic?
    var router: (NSObjectProtocol & InitializationRoutingLogic & InitializationDataPassing)?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
        //getQuotes()
        getIFIX()
        interactor?.getMessages(type: .received)
        interactor?.getIndexes()
        interactor?.getNewOrUpdatedItem()
        interactor?.getUserData()
        setscheduled()
        _ = NewsletterViewController()
        interactor?.getBasicSalary()
        interactor?.getNewsletter()
    }
    
    // MARK: Setup
    
    private func setup() {
        let interactor = InitializationInteractor()
        let presenter = InitializationPresenter()
        let router = InitializationRouter()
        
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
        loading = view.loading()
        setupLayout()
        //        DispatchQueue.main.async {
        //            self.segueTo(destination: self.storyboard?.instantiateViewController(withIdentifier: "home") as! HomeViewController)
        //        }
        
        if InitializationViewController.showOpenAd, UserDefaultKeys.vip.getValue() as! Bool == false {
            DispatchQueue.main.async {
                AppOpenAdManager.shared.showAdIfAvailable(viewController: self)
                InitializationViewController.showOpenAd = false
            }
        }
    }
    
    @objc private func getQuotes() {
        interactor?.getQuotes()
    }
    
    @objc private func getIFIX() {
        interactor?.getIndexIFIX()
    }
    
    private func setupLayout() {}
    
    private func setscheduled() {
        Timer.scheduledTimer(timeInterval: InitializationModel.customTimeInterval, target: self, selector: #selector(getIFIX), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: InitializationModel.customTimeInterval, target: self, selector: #selector(getQuotes), userInfo: nil, repeats: true)
    }
    
    func resultFirstAccessOfTheDay(_ result: Bool) {
        print(result)
    }
    
    func flagNewOrUpdatedItem(_ list: [(ItemsLibrary, Bool)]) {
        InitializationModel.arrayFlagNewOrUpdatedItem = list
    }
    
    func callHomeViewController() {
        HomeViewController().showTopics(.init())
        loading = nil
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            self.segueTo(destination: self.storyboard?.instantiateViewController(withIdentifier: "home") as! HomeViewController)
        }
    }
}

