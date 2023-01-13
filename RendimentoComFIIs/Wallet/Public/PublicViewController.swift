//
//  ViewController.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

protocol PublicDisplayLogic {
    func showSomething(_ object: PublicModel.Fetch.Public)
}


class PublicViewController: UIViewController, PublicDisplayLogic {
    
    @IBOutlet weak var viewHeader: NavigationBarHeaderView!
    @IBOutlet weak var textviewDescription: UITextView!
    @IBOutlet var collectionLabel: [UILabel]!
    
    let placeholderText = NSLocalizedString("placeholder_publicwallet", comment: "")
    let limitLetters = 300
    
    var interactor: PublicBusinessLogic?
    var router: (NSObjectProtocol & PublicRoutingLogic & PublicDataPassing)?
    
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
        let interactor = PublicInteractor()
        let presenter = PublicPresenter()
        let router = PublicRouter()
        
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
        addDoneButtonOnKeyboard()
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
        
        textviewDescription.delegate = self
        textviewDescription.setup(placeholderText)
        
        collectionLabel.forEach {
            $0.font = UIFont.boldSystemFont(ofSize: 12)
            $0.textColor = $0.isEqual(collectionLabel.first) ? .label : .systemRed
            $0.textAlignment = $0.isEqual(collectionLabel.first) ? .right : .left
            $0.text = $0.isEqual(collectionLabel.first) ? "Total: 0" : "Max: \(limitLetters)"
        }
    }
    
    private func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle       = UIBarStyle.default
        let flexSpace              = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem  = UIBarButtonItem(title: "Concluir", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.doneKeyboardNumber))
        done.tintColor = UIColor(named: "Font")
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        textviewDescription.inputAccessoryView = doneToolbar
        
    }
    
    @objc func doneKeyboardNumber() {
        view.closeKeyboard()
    }
    
    func showSomething(_ object: PublicModel.Fetch.Public) {
        
    }
    
}


extension PublicViewController: NavigationBarHeaderDelegate {
    func didTapButtonBack(_ sender: UIButton) {
        dismissWith()
    }
}


extension PublicViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        _ = textViewShouldBeginEditing(textView)
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        
        if updatedText.isEmpty {
            textviewDescription.setup(placeholderText)
            DispatchQueue.main.async {
                self.collectionLabel.first?.text = "Total: 0"
            }
            return true
        } else {
            DispatchQueue.main.async {
                self.collectionLabel.first?.text = "Total: \(updatedText.count)"
            }
        }
        return updatedText.count >= limitLetters ? false : true
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textviewDescription.tag == 0 {
            textviewDescription.text.removeAll()
            textviewDescription.tag = 1
            textView.textColor = .label
        }
        return true
    }
    
    //    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
    //        view.closeKeyboard()
    //        return true
    //    }
    
    
}

