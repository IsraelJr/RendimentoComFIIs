//
//  ContactUsViewController.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 13/05/22.
//

import UIKit

protocol ContactUsDisplayLogic {
    func showSuccess(_ message: String!)
    func showError(_ message: String!)
}



class ContactUsViewController: UIViewController, ContactUsDisplayLogic {
    
    @IBOutlet weak var viewHeader: NavigationBarHeaderView!
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet var collectionView: [UIView]!
    @IBOutlet var collectionTextField: [UITextField]!
    @IBOutlet weak var tvMessage: UITextView!
    @IBOutlet var collectionViewButton: [UIView]!
    @IBOutlet var collectionButton: [UIButton]!
    @IBOutlet var collectionRadio: [UIButton]!
    @IBOutlet weak var lbAttachedInfo: UILabel!
    @IBOutlet weak var btnAttach: UIButton!
    
    var isSuccess = false
    var document: UIImage?
    var attach: String?
    
    var interactor: ContactUsBusinessLogic?
    var router: (NSObjectProtocol & ContactUsRoutingLogic & ContactUsDataPassing)?
    
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
        let interactor = ContactUsInteractor()
        let presenter = ContactUsPresenter()
        let router = ContactUsRouter()
        
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
        NotificationCenter.default.addObserver(self, selector: #selector(self.adjustForKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        
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
        viewHeader.delegate = self
        viewHeader.setTitleHeader(name: NSLocalizedString("contact_us", comment: ""))
        
        viewMain.backgroundColor = UIColor(named: "Border")
        viewMain.layer.cornerRadius = 40
        
        collectionView.forEach({
            $0.backgroundColor = .systemBackground
            $0.layer.borderWidth = 2
            $0.layer.borderColor = UIColor.clear.cgColor
            $0.layer.cornerRadius = $0 == collectionView.first ? $0.frame.height/2 : collectionView.first!.layer.cornerRadius
        })
        
        collectionTextField.forEach({
            $0.delegate = self
            $0.backgroundColor = .clear
            $0.borderStyle = .none
            $0.font = UIFont.boldSystemFont(ofSize: 16)
            $0.returnKeyType = .next
            $0.keyboardType = $0 == collectionTextField.first ? .alphabet : .emailAddress
            $0.text = $0 == collectionTextField.first ? DataUser.name ?? "" : DataUser.email ?? ""
            $0.isEnabled = $0.text?.isEmpty ?? true ? true : false
            $0.textColor = $0.isEnabled ? .label : .placeholderText
            $0.placeholder = $0 == collectionTextField.first ? NSLocalizedString("name", comment: "") : NSLocalizedString("email", comment: "")
        })
        
        tvMessage.delegate = self
        insertPlaceholderTvMessage()
        tvMessage.backgroundColor = collectionTextField.first?.backgroundColor
        tvMessage.textColor = collectionTextField.first?.textColor
        tvMessage.enablesReturnKeyAutomatically = true
        tvMessage.keyboardType = .alphabet
        insertPlaceholderTvMessage()
        
        collectionViewButton.forEach({
            $0.backgroundColor = $0 == collectionViewButton.first ? view.backgroundColor : UIColor(named: "Font")
        })
        
        collectionButton.forEach({
            $0.backgroundColor = .clear
            $0.setTitleColor($0 == collectionButton.first ? collectionViewButton.last?.backgroundColor : collectionViewButton.first?.backgroundColor, for: .normal)
            $0.setTitle($0 == collectionButton.first ? NSLocalizedString("clear", comment: "") : NSLocalizedString("send", comment: ""), for: .normal)
            $0.isEnabled = $0 == collectionButton.first ? true : false
        })
        initializeRadio()
        
        btnAttach.setTitle(NSLocalizedString("attach_image", comment: ""), for: .normal)
        
        lbAttachedInfo.text?.removeAll()
        lbAttachedInfo.textColor = .white
        lbAttachedInfo.numberOfLines = 1
        lbAttachedInfo.adjustsFontSizeToFitWidth = true
        lbAttachedInfo.minimumScaleFactor = 0.1
    }
    
    private func initializeRadio() {
        for i in 0..<collectionRadio.count {
            collectionRadio[i].setupDefault(35, "circle.circle", " \(TypeMessageTitle.allCases[i].description())")
            collectionRadio[i].tintColor = UIColor().colorRadioDisabled
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
        
        tvMessage.inputAccessoryView = doneToolbar
        
    }
    
    private func insertPlaceholderTvMessage() {
        tvMessage.text.removeAll()
        tvMessage.insertTextPlaceholder(with: CGSize(width: 100, height: 40))
        tvMessage.insertText(NSLocalizedString("message", comment: ""))
        tvMessage.textColor = .placeholderText
        tvMessage.font = collectionTextField.first?.font
        tvMessage.resignFirstResponder()
        tvMessage.tag = 0
    }
    
    private func changeColorView(_ to: AlertType) {
        let color = to == .error ? UIColor.systemRed.cgColor : UIColor.clear.cgColor
        for i in 0..<collectionTextField.count {
            collectionView[i].layer.borderColor = collectionTextField[i].text!.isEmpty ? color : UIColor.clear.cgColor
        }
        
        if tvMessage.text.isEmpty || tvMessage.text.elementsEqual(NSLocalizedString("message", comment: "")) {
            collectionView[3].layer.borderColor = color
        } else {
            collectionView[3].layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    @objc func doneKeyboardNumber() {
        view.closeKeyboard()
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            scroll.contentInset = .zero
        } else {
            scroll.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        scroll.scrollIndicatorInsets = scroll.contentInset
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
    
    func showSuccess(_ message: String!) {
        _ = alertView(type: .success, message: message).delegate = self
        changeColorView(.success)
        isSuccess = true
    }
    
    func showError(_ message: String!) {
        _ = alertView(type: .error, message: message).delegate = self
        changeColorView(.error)
        message.elementsEqual(NSLocalizedString("error_email", comment: "")) ? collectionView[1].layer.borderColor = UIColor.systemRed.cgColor : nil
        message.contains(NSLocalizedString("pix", comment: "")) ? (btnAttach.layer.borderColor = UIColor.systemRed.cgColor, btnAttach.layer.borderWidth = collectionView[1].layer.borderWidth) : nil
        
    }
    
    @IBAction func didTapBtnContactUs(_ sender: UIButton) {
        if sender == collectionButton.first {
            //            collectionTextField.forEach({ $0.text?.removeAll() })
            insertPlaceholderTvMessage()
            initializeRadio()
        } else {
            let option = TypeMessageTitle(rawValue: NSLocalizedString((collectionRadio.first(where: {$0.tintColor == UIColor().colorRadioActive})?.currentTitle!.trimmingCharacters(in: .whitespacesAndNewlines))!, comment: ""))
            interactor?.saveMessage(.init(object: .init(name: collectionTextField.first?.text,
                                                        email: collectionTextField.last?.text,
                                                        typeTitle: option,
                                                        message: tvMessage.text,
                                                        attach: attach)))
        }
    }
    
    @IBAction func didTapRadio(_ sender: UIButton) {
        collectionRadio.forEach({
            $0 == sender ? $0.setImage(UIImage(systemName: "circle.circle.fill"), for: .normal) : $0.setImage(UIImage(systemName: "circle.circle"), for: .normal)
            $0.tintColor = $0 == sender ? UIColor().colorRadioActive : UIColor().colorRadioDisabled
        })
        collectionButton.last?.isEnabled = true
        view.closeKeyboard()
    }
    
    @IBAction func showAttach(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "attach") as! AttachViewController
        vc.delegate = self
        present(vc, animated: true)
    }
}


extension ContactUsViewController: NavigationBarHeaderDelegate {
    func didTapButtonBack(_ sender: UIButton) {
        dismissWith()
    }
}


extension ContactUsViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        _ = textViewShouldBeginEditing(textView)
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        
        if updatedText.isEmpty {
            insertPlaceholderTvMessage()
            return false
        } else {
            //            let defaultText = NSLocalizedString("message", comment: "")
            //            if updatedText.contains(defaultText.prefix(defaultText.count-1)) {
            //                textView.text = nil
            //                return true
            //            } else {
            //                textView.text = updatedText
            //            }
        }
        return true
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        //        if self.view.window != nil {
        //            if textView.textColor == UIColor.lightGrayColor() {
        //                textView.selectedTextRange = textView.textRangeFromPosition(textView.beginningOfDocument, toPosition: textView.beginningOfDocument)
        //            }
        //        }
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if tvMessage.tag == 0 {
            tvMessage.text.removeAll()
            tvMessage.tag = 1
            textView.textColor = collectionTextField.first?.textColor
            let bottomOffset = CGPoint(x: 0, y: scroll.contentSize.height - scroll.bounds.height + scroll.contentInset.bottom)
            scroll.setContentOffset(bottomOffset, animated: true)
        }
        let bottomOffset = CGPoint(x: 0, y: scroll.contentSize.height - scroll.bounds.height + scroll.contentInset.bottom)
        scroll.setContentOffset(bottomOffset, animated: true)
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        let bottomOffset = CGPoint(x: 0, y: scroll.contentSize.height - scroll.bounds.height + scroll.contentInset.top)
        scroll.setContentOffset(bottomOffset, animated: true)
        view.closeKeyboard()
        return true
    }
    
    
}

extension ContactUsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == collectionTextField.first {
            collectionTextField.last?.becomeFirstResponder()
        } else {
            tvMessage.becomeFirstResponder()
        }
        return false
    }
}


extension ContactUsViewController: ActionButtonAlertDelegate {
    func close() {
        dismiss(animated: true) {
            self.isSuccess ? self.dismissWith() : nil
        }
    }
}


extension ContactUsViewController: AttachViewControllerDelegate {
    func close(image: UIImage?) {
        guard let _ = image else {
            lbAttachedInfo.text = NSLocalizedString("attach_error", comment: "")
            return
        }
        attach = image?.jpegData(compressionQuality: 0.1)?.base64EncodedString()
        lbAttachedInfo.text = NSLocalizedString("attach_success", comment: "")
        btnAttach.layer.borderColor = UIColor.clear.cgColor
    }
}
