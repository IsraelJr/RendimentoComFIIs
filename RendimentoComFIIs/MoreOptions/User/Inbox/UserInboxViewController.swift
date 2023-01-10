//
//  ViewController.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

protocol UserInboxDisplayLogic {
    func deleteMessage(_ deleted: Bool)
    func showMessages(_ list: [UserInboxModel.Fetch.Message])
}

class UserInboxViewController: UIViewController, UserInboxDisplayLogic {
    
    @IBOutlet weak var viewHeader: NavigationBarHeaderView!
    @IBOutlet weak var stackOption: UIStackView!
    @IBOutlet weak var btnInbox: UIButton!
    @IBOutlet weak var btnSent: UIButton!
    @IBOutlet weak var tableMessages: UITableView!
    @IBOutlet weak var btnDeleteMessage: UIButton!
    
    var interactor: UserInboxBusinessLogic?
    var router: (NSObjectProtocol & UserInboxRoutingLogic & UserInboxDataPassing)?
    
    var listReceivedMessages: [UserInboxModel.Fetch.Message]?
    var listSentMessages: [UserInboxModel.Fetch.Message]?
    var listDeleteMessage: [UserInboxModel.Fetch.Message]?
    var temp: [UserInboxModel.Fetch.Message]?
    
    var position: IndexPath?
    
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
        let interactor = UserInboxInteractor()
        let presenter = UserInboxPresenter()
        let router = UserInboxRouter()
        
        self.interactor = interactor
        self.router = router
        interactor.presenter = presenter
        presenter.viewController = self
        router.viewController = self
        router.dataStore = interactor
        
        interactor.getMessages(type: .sent)
        interactor.getMessages(type: .received)
        
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
        viewHeader.setTitleHeader(name: NSLocalizedString("inbox", comment: ""))
        
        tableMessages.delegate = self
        tableMessages.dataSource = self
        tableMessages.backgroundColor = .clear
        
        btnInbox.setTitle(NSLocalizedString("inbox", comment: ""), for: .normal)
        btnSent.setTitle(NSLocalizedString("sent", comment: ""), for: .normal)
        
        didTapOption(btnInbox)
        
        btnDeleteMessage.setTitle(NSLocalizedString("delete_message", comment: ""), for: .normal)
    }
    
    private func messageRead(_ message: UserInboxModel.Fetch.Message) {
        if message.owner.elementsEqual(InitializationModel.systemName) {
            DispatchQueue.main.async { [self] in
                interactor?.markAsRead(request: message)
                var msg = InitializationModel.listMessagesReceived.remove(at: InitializationModel.listMessagesReceived.firstIndex(where: { $0.idBD.elementsEqual(message.idBD) })!)
                msg.read = true
                InitializationModel.listMessagesReceived.append(msg)
                tableMessages.reloadData()
            }
        }
    }
    
    private func showAlert(_ type: AlertType, _ message: String!, _ titleBtnYes: String) {
        let alert = self.alertView(type: type, message: message)
        let textClose = titleBtnYes.isEmpty ? "close" : "clean_no"
        alert.setupBtnYes(titleYes: titleBtnYes, titleNo: NSLocalizedString(textClose, comment: ""))
        alert.yes.isHidden = titleBtnYes.isEmpty ? true : false
        alert.delegate = self
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
    
    func deleteMessage(_ deleted: Bool) {
        if deleted {
            if stackOption.arrangedSubviews.first?.tintColor == .label {
                if let _ = listDeleteMessage {
                    listDeleteMessage = nil
                    listReceivedMessages = nil
                    temp = nil
                } else {
                    listReceivedMessages?.remove(at: position!.row)
                }
            } else {
                if let _ = listDeleteMessage {
                    listDeleteMessage = nil
                    listSentMessages = nil
                    temp = nil
                } else {
                    listSentMessages?.remove(at: position!.row)
                }
            }
            temp?.remove(at: position!.row)
            didTapOption(listSentMessages?.isEmpty ?? true ? btnInbox : btnSent)
            showAlert(.success, NSLocalizedString("delete_message_success", comment: ""), "")
        } else {
            showAlert(.error, NSLocalizedString("delete_message_error", comment: ""), "")
        }
    }
    
    func showMessages(_ list: [UserInboxModel.Fetch.Message]) {
        DispatchQueue.main.async { [self] in
            if !list.isEmpty {
                switch list.first!.typeMessage {
                case .sent:
                    listSentMessages = list.sorted(by: { $0.date.convertDateToInt() > $1.date.convertDateToInt() })
                    didTapOption(btnSent)
                case .received:
                     listReceivedMessages = list.sorted(by: { $0.date.convertDateToInt() > $1.date.convertDateToInt() })
                    didTapOption(btnInbox)
                }
            }
        }
    }
    
    @IBAction func didTapOption(_ sender: UIButton) {
        if stackOption.arrangedSubviews.contains(sender) {
            stackOption.arrangedSubviews.forEach { btn in
                btn.tintColor = sender.isEqual(btn as! UIButton) ? .label : .lightGray
                temp = sender.isEqual(btnInbox) ? listReceivedMessages : listSentMessages
            }
        }
        if sender.isEqual(btnDeleteMessage) {
            listDeleteMessage = temp
            showAlert(.warning, NSLocalizedString("ask_delete_all_message", comment: ""), NSLocalizedString("clean_yes", comment: ""))
        } else {
            tableMessages.reloadData()
        }
    }
    
}


extension UserInboxViewController: NavigationBarHeaderDelegate {
    func didTapButtonBack(_ sender: UIButton) {
        dismissWith()
    }
}


extension UserInboxViewController: ActionButtonAlertDelegate {
    func close() {
        dismiss(animated: true)
    }
    
    func yes() {
        interactor?.deleteMessage(request: (temp![position?.row ?? 0]), listDeleteMessage)
        dismiss(animated: true)
    }
}


extension UserInboxViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        btnDeleteMessage.isEnabled = temp?.count ?? 0 > 0 ? true : false
        return temp?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UserInboxTableViewCell
        var message = temp![indexPath.row]
        message.read = message.typeMessage == .received ? InitializationModel.listMessagesReceived.first(where: { $0.idBD.elementsEqual(message.idBD) })?.read ?? false : true
        cell.setData(message)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var list = [UserInboxModel.Fetch.Message]()
        InitializationModel.listMessagesReceived.forEach({
            $0.read == false ? list.append($0) : nil
        })
        let text = temp?.first?.typeMessage == .received ? " e \(list.count) não lida\(list.count > 1 ? "s" : "")" : ""
        return "\(NSLocalizedString("total_message", comment: "").replacingOccurrences(of: "xXx", with: "\(temp?.count ?? 0)"))\(text)"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            position = indexPath
            showAlert(.info, NSLocalizedString("ask_delete_message", comment: ""), NSLocalizedString("clean_yes", comment: ""))
        }
    }
}


extension UserInboxViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "inboxMessage") as! UserInboxMessageViewController
        vc.objMessage = temp?[indexPath.row]
        vc.title = (stackOption.arrangedSubviews.first(where: { $0.tintColor == .label} ) as! UIButton).currentTitle
        present(vc, animated: true) {
            vc.objMessage?.read == true ? nil : self.messageRead(vc.objMessage!)
        }
        
        
    }
}
