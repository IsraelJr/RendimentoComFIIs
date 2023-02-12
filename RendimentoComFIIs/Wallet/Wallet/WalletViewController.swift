//
//  WalletViewController.swift
//  RendimentoComFII
//
//  Created by Israel Alves on 24/04/22.
//

import UIKit
import Lottie

protocol WalletDisplayLogic {
    func successWallet(_ wallet: WalletModel.Fetch.Wallet)
    func errorWallet(_ msg: String)
}


class WalletViewController: UIViewController, WalletDisplayLogic {
    
    @IBOutlet weak var viewHeader: NavigationBarHeaderView!
    @IBOutlet weak var tableMyFiis: UITableView!
    @IBOutlet weak var btnAddNewFii: UIButton!
    @IBOutlet weak var moreOptions: LottieAnimationView!
    
    static var wallet: WalletModel.Fetch.Wallet?
    
    var dataEdit: EditFii?
    var totalEarnings: Double = 0.0
    var list = [(String,Int64)]()
    var listTemp = [(String,Int64)]()
    
    var interactor: WalletBusinessLogic?
    var router: (NSObjectProtocol & WalletRoutingLogic & WalletDataPassing)?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
        Ad.checkSponsor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
        Ad.checkSponsor()

    }
    
    // MARK: Setup
    
    private func setup() {
        let interactor = WalletInteractor()
        let presenter = WalletPresenter()
        let router = WalletRouter()
        
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
        readWalletLocal()
        listTemp = list
        setupLayout()
        WalletViewController.wallet == nil ? interactor?.accessWalletBD(action: .read, nil) : nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        readWalletLocal()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        interactor?.accessWalletBD(action: .create, list)
        interactor?.setMonthlyEarnings(totalEarnings)
        
    }
    
    private func setupLayout() {
        viewHeader.setTitleHeader(name: NSLocalizedString("title_wallet", comment: ""))
        viewHeader.btnReturn.isHidden = true
        
        tableMyFiis.delegate = self
        tableMyFiis.dataSource = self
        tableMyFiis.backgroundColor = .clear
        
        btnAddNewFii.setTitle(NSLocalizedString("add_new_fii", comment: ""), for: .normal)
        
        let viewFooter = view.createNavigationBarFooter(position: 1)
        viewFooter.delegate = self
        
        _ = moreOptions.loadingLottie("more", 1)
        moreOptions.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(respondToTapGesture))
        self.moreOptions.addGestureRecognizer(tap)
        
    }
    
    @objc func respondToTapGesture(gesture: UITapGestureRecognizer) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "moreOptionsWallet") as! MoreOptionsWalletViewController
        segueTo(destination: vc)
    }
    
    
    
    private func presentConfigureFii() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "configureFii") as! ConfigureWalletFIIViewController
        vc.insert = .fii
        vc.title = dataEdit?.title
        vc.code = dataEdit?.code ?? ""
        vc.quotas = dataEdit?.quotas ?? ""
        vc.vcWallet = self
        present(vc, animated: false)
    }
    
    private func readWalletLocal() {
        list.removeAll()
        totalEarnings = 0.0
        ListFii.listFiis.forEach({
            let data = Util.userDefaultForWallet(action: .read, code: $0.code)
            if data.code.isEmpty == false /*, data.quotas > 0*/ {
                if !list.contains(where: {$0.0.contains(data.code)}) {
                    list.append((data.code, data.quotas))
                    let monthCurrent = $0.earnings?.first(where: {$0.key.elementsEqual(Month.current.description().0)})
                    let y = String((monthCurrent?.value["earnings"] as? String ?? "R$ 0,0").split(separator: " ")[1]).convertCurrencyToDouble()
                    totalEarnings += (y * Double(data.quotas))
                }
            }
        })
        DispatchQueue.main.async {
            self.tableMyFiis.reloadData()
        }
    }
    
    func successWallet(_ wallet: WalletModel.Fetch.Wallet) {
        WalletViewController.wallet = wallet
        list.isEmpty ? readWalletLocal() : nil
    }
    
    func errorWallet(_ msg: String) {
        print(#function)
    }
    
    @IBAction func didTapAddNewFii(_ sender: UIButton) {
        dataEdit = .init(title: NSLocalizedString("title_config_wallet_add", comment: ""), code: "", quotas: "")
        presentConfigureFii()
    }
    
}


extension WalletViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WalletTableViewCell
        list.sort(by: { $0.0 < $1.0 })
        cell.setData(list[indexPath.row])
        cell.btnEdit.tag = indexPath.row
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(NSLocalizedString("title_table", comment: "")) \(NSLocalizedString(Month.current.description().0, comment: "")): \(totalEarnings.convertToCurrency(true))"
    }
    
}


extension WalletViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! WalletTableViewCell
        interactor?.setFii(.init(socialReason: "", name: nil, code: (cell.img.subviews[0] as! UILabel).text!, segment: nil, price: nil, earnings: nil))
        router?.routeTosegueFIIWithSegue(segue: nil)
    }
}


extension WalletViewController: ActionButtonEditDelegate {
    func didTapEditQuotas(_ sender: UIButton) {
        sender.pulseEffectInClick()
        let cell = tableMyFiis.cellForRow(at: IndexPath.init(row: sender.tag, section: 0)) as! WalletTableViewCell
        dataEdit = .init(title: NSLocalizedString("title_config_wallet_edit", comment: ""), code: (cell.img.subviews[0] as! UILabel).text!, quotas: cell.lbQuotas.text?.replacingOccurrences(of: NSLocalizedString("quota", comment: ""), with: "") ?? "")
        presentConfigureFii()
    }
}


extension WalletViewController: NavigationBarFooterDelegate {
    func didTapButtonNavigation(_ sender: UIButton) {
        var vc: UIViewController!
        switch sender.tag {
        case 0:
            vc = storyboard?.instantiateViewController(withIdentifier: "home") as! HomeViewController
            present(vc, animated: false)
            
        case 2:
            vc = storyboard?.instantiateViewController(withIdentifier: "search") as! SearchViewController
            present(vc, animated: false)
            
        case 3:
            vc = storyboard?.instantiateViewController(withIdentifier: "moreOptions") as! MoreOptionsViewController
            present(vc, animated: false)
            
        default:
            break
        }
    }
}
