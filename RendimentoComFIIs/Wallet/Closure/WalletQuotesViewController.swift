//
//  WalletQuotesViewController.swift
//  RendimentoComFII
//
//  Created by Israel Alves on 24/04/22.
//

import UIKit
import Lottie

protocol WalletQuotesDisplayLogic {
    //    func successSaveMonth(_ msg: String)
    //    func errorSaveMonth(_ msg: String)
}


class WalletQuotesViewController: UIViewController, WalletQuotesDisplayLogic {
    
    @IBOutlet weak var viewHeader: NavigationBarHeaderView!
    @IBOutlet weak var tableMyFiis: UITableView!
    
    var loading: LottieAnimationView?
    
    struct FIIs {
        var code: String
        var price: String
        var variacao: String
        var percent: String
        var dateLastUpdate: String
    }
    
    var result = [FIIs]()
    
    
    //    var interactor: WalletQuotesBusinessLogic?
    //    var router: (NSObjectProtocol & WalletQuotesRoutingLogic & WalletQuotesDataPassing)?
    
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
        //        let interactor = WalletQuotesInteractor()
        //        let presenter = WalletQuotesPresenter()
        //        let router = WalletQuotesRouter()
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
        //        let vc = segue.destination as! ConfigureWalletFIIViewController
        //        vc.insert = .month
        //        vc.title = dataEdit?.title
        //        vc.code = dataEdit?.code ?? ""
        //        vc.quotas = dataEdit?.quotas ?? ""
        //        vc.vcWallet = self
        //  /Users/israelalves/Downloads/more.json      present(vc, animated: false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loading = view.loadingLottie("bar_graph")
        setupLayout()
        testeExtracao { response in
            DispatchQueue.main.async {
                self.loading?.removeFromSuperview()
                self.tableMyFiis.reloadData()
            }
        }
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    private func setupLayout() {
        viewHeader.setTitleHeader(name: NSLocalizedString("quotes", comment: ""))
        viewHeader.delegate = self
        
        tableMyFiis.delegate = self
        tableMyFiis.dataSource = self
        tableMyFiis.backgroundColor = .clear
        
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
    
    
    private func testeExtracao(complete:@escaping(responseDone)) {
        var fiis = [String]()
        ListFii.listFiis.forEach({
            let data = Util.userDefaultForWallet(action: .read, code: $0.code)
            if data.code.isEmpty == false /*, data.quotas > 0*/ {
                if !fiis.contains(where: {$0.contains(data.code)}) {
                    fiis.append(data.code)
                }
            }
        })
        if fiis.isEmpty {
            complete(false)
        } else {
            fiis.forEach({ item in
                let site = "https://brapi.dev/api/quote/\(item)\(Bundle.main.infoDictionary!["TokenBrapi"]!)"
                let url = URL(string: site)
                let request = URLSession.shared.dataTask(with: url!) {(data, response, error) in
                    if error != nil {
                        complete(false)
                    }
                    do {
                        
                        if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                            if let results = json.first(where: {$0.key.elementsEqual("results")})?.value.self,
                                let fii = ((results as! [Any]).first as? [String:Any]) {
                                
                                let code = fii["symbol"] as? String ?? ""
                                var price = fii["regularMarketPrice"] as? Double ?? 0
                                var variacao = fii["regularMarketChange"] as? Double ?? 0
                                var percent = fii["regularMarketChangePercent"] as? Double ?? 0
                                let dateLastUpdate = fii["regularMarketTime"] as? String ?? ""
                                
                                let divisor = pow(10.0, Double(2))
                                
                                price = round(price * divisor) / divisor
                                variacao = round(variacao * divisor) / divisor
                                percent = round(percent * divisor) / divisor
                                
                                print(dateLastUpdate.dateTextWithYYYY())
                                
                                self.result.append(.init(code: code, price: price.convertToCurrency(true), variacao: variacao.description, percent: "\(percent)%", dateLastUpdate: dateLastUpdate.dateTextWithYYYY()))

                                if self.result.count == fiis.count {
                                    self.result.sort(by: {$0.code < $1.code})
                                    complete(true)
                                }
                            } else {
                                complete(false)
                            }
                        } else {
                            complete(false)
                        }
                    } catch {
                        complete(false)
                    }
                }
                request.resume()
            })
        }
    }
    
    
}


extension WalletQuotesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return result.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellQuotes", for: indexPath) as! WalletTableViewCell
        let value = "\(result[indexPath.row].price)    \(result[indexPath.row].variacao)    \(result[indexPath.row].percent)"
        cell.setDataQuotes((result[indexPath.row].code, value, result[indexPath.row].dateLastUpdate))
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return result.count > 0 ? NSLocalizedString("not_realtime", comment: "") : (self.loading == nil ? NSLocalizedString("no_fiis", comment: "") : "")
    }
    
}


extension WalletQuotesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        let cell = tableView.cellForRow(at: indexPath) as! WalletTableViewCell
        //        tableView.reloadData()
    }
}


extension WalletQuotesViewController: NavigationBarHeaderDelegate {
    func didTapButtonBack(_ sender: UIButton) {
        dismissWith()
    }
}


extension WalletQuotesViewController: ActionButtonAlertDelegate {
    func close() {
        dismiss(animated: true)
    }
}
