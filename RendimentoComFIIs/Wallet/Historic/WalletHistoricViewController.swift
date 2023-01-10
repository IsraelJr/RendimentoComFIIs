//
//  WalletHistoricViewController.swift
//  RendimentoComFII
//
//  Created by Israel Alves on 24/04/22.
//

import UIKit
import GoogleMobileAds

protocol WalletHistoricDisplayLogic {
    func successSaveMonth(_ msg: String)
    func errorSaveMonth(_ msg: String)
}


class WalletHistoricViewController: UIViewController, WalletHistoricDisplayLogic {
    
    @IBOutlet weak var viewHeader: NavigationBarHeaderView!
    @IBOutlet weak var tableMyFiis: UITableView!
    @IBOutlet weak var btnAddMonth: UIButton!
    @IBOutlet weak var viewBanner: GADBannerView!
    
    var dataEdit: EditFii?
    var totalEarnings: Double = 0.0
    var listYears = [(String,Double)]()
    var listMonth = [(String,Double)]()
    var yearSelected = ""
    var updateMonth = ""
    
    var interactor: WalletHistoricBusinessLogic?
    var router: (NSObjectProtocol & WalletHistoricRoutingLogic & WalletHistoricDataPassing)?
    
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
        let interactor = WalletHistoricInteractor()
        let presenter = WalletHistoricPresenter()
        let router = WalletHistoricRouter()
        
        self.interactor = interactor
        self.router = router
        interactor.presenter = presenter
        presenter.viewController = self
        router.viewController = self
        router.dataStore = interactor
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Ad.showBanner(viewBanner, self)
        setupLayout()
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateMonth.isEmpty ? nil : interactor?.accessWalletHistoric(action: .create, (month: updateMonth, year: yearSelected))
        tableMyFiis.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //        interactor?.accessWalletHistoric(action: .create)
    }
    
    private func setupLayout() {
        viewHeader.setTitleHeader(name: "      \(NSLocalizedString("title_wallet_historic", comment: ""))")
        viewHeader.delegate = self
        
        tableMyFiis.delegate = self
        tableMyFiis.dataSource = self
        tableMyFiis.backgroundColor = .clear
        
        btnAddMonth.setTitle(NSLocalizedString("add_month", comment: ""), for: .normal)
        btnAddMonth.isEnabled = false
        
        WalletViewController.wallet?.annualEarnings?.forEach({ item in
            var total: Double = 0.0
            let values = item.value as? [String:Double]
            values?.forEach({
                total += $0.1
            })
            listYears.append((item.key, total))
        })
        listYears.count == 1 ? listYears.append(((Int(listYears.first!.0)!-1).description, 0.0)) : nil
        listYears.sort(by: {$0.0 > $1.0})
        
    }
    
    private func presentConfigureFii() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "configureFii") as! ConfigureWalletFIIViewController
        vc.insert = .month
        vc.title = dataEdit?.title
        vc.code = dataEdit?.code ?? ""
        vc.quotas = dataEdit?.quotas ?? ""
        vc.vcWallet = self
        present(vc, animated: false)
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
    
    func showWalletHistoric(_ isOk: Bool) {
        tableMyFiis.reloadData()
    }
    
    func successSaveMonth(_ msg: String) {
        alertView(type: .success, message: msg).delegate = self
    }
    
    func errorSaveMonth(_ msg: String) {
        if msg.contains(NSLocalizedString("critical_error", comment: "").prefix(20)) {
            alertView(type: .error, message: msg).delegate = self
        } else {
            alertView(type: .warning, message: msg).delegate = self
        }
    }
    
    @IBAction func didTapAddMonth(_ sender: UIButton) {
        dataEdit = .init(title: "\(NSLocalizedString("add_month", comment: "")) (\(yearSelected))", code: " ", quotas: " ")
        presentConfigureFii()
    }
    
}


extension WalletHistoricViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listMonth.count > 0 ? listMonth.count : listYears.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WalletTableViewCell
        if listMonth.count > 0 {
            cell.setDataHistoric(listMonth[indexPath.row])
            cell.btnEdit.tag = indexPath.row
            cell.delegate = self
            listMonth[indexPath.row].1 == 0.0 ? cell.isHidden = true : nil
            cell.animateTransition(indexPath.row)
        } else {
            cell.setDataHistoric(listYears[indexPath.row])
            cell.btnEdit.tag = indexPath.row
            cell.delegate = self
            yearSelected.isEmpty ? nil : cell.animateTransition(indexPath.row)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var total: Double = 0.0
        var text = NSLocalizedString("accumulated", comment: "")
        if listMonth.isEmpty {
            listYears.forEach({
                total += $0.1
            })
            text = "\(text) \(total.convertToCurrency(true))"
        } else {
            listMonth.forEach({
                total += $0.1
            })
            text = "\(text.replacingOccurrences(of: ":", with: "")) \(yearSelected): \(total.convertToCurrency(true))"
        }
        return text
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if !listMonth.isEmpty, UserDefaultKeys.vip.getValue() as! Bool {
            btnAddMonth.isEnabled = true
            viewBanner.isHidden = btnAddMonth.isEnabled
        } else {
            btnAddMonth.isEnabled = false
        }
    }
}


extension WalletHistoricViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! WalletTableViewCell
        let option = (cell.img.subviews[0] as! UILabel).text!
        if option.contains("2") {
            var temp = [(String,Double)]()
            let values = WalletViewController.wallet?.annualEarnings?.first(where: {$0.key.elementsEqual(option)})?.value as? [String:Double]
            values?.forEach({
                temp.append(($0.key, $0.value))
            })
            for i in 1...12 {
                let x = temp.first(where: { $0.0.elementsEqual(NSLocalizedString("\(i)", comment: "")) })
                x?.1 ?? 0.0 > 0.0 ? listMonth.append(x!) : nil
            }
            listMonth.isEmpty ? listMonth.append(("", 0.0)) : nil
            yearSelected = option
        } else {
            listMonth.removeAll()
        }
        tableView.reloadData()
    }
}


extension WalletHistoricViewController: ActionButtonEditDelegate {
    func didTapEditQuotas(_ sender: UIButton) {
        let cell = tableMyFiis.cellForRow(at: IndexPath.init(row: sender.tag, section: 0)) as! WalletTableViewCell
        dataEdit = .init(title: NSLocalizedString("title_config_wallet_edit", comment: ""), code: (cell.img.subviews[0] as! UILabel).text!, quotas: cell.lbQuotas.text?.replacingOccurrences(of: NSLocalizedString("quota", comment: ""), with: "") ?? "")
        presentConfigureFii()
    }
}


extension WalletHistoricViewController: NavigationBarHeaderDelegate {
    func didTapButtonBack(_ sender: UIButton) {
        dismissWith()
    }
}


extension WalletHistoricViewController: ActionButtonAlertDelegate {
    func close() {
        dismiss(animated: true)
    }
}
