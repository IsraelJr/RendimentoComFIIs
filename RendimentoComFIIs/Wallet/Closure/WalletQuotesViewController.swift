//
//  WalletQuotesViewController.swift
//  RendimentoComFII
//
//  Created by Israel Alves on 24/04/22.
//

import UIKit
import SwiftSoup
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
                let site = "https://finance.yahoo.com/quote/\(item).SA?p=\(item).SA&.tsrc=fin-srch"
                let url = URL(string: site)
                let taskUm = URLSession.shared.dataTask(with: url!) {(data, response, error) in
                    if error != nil {
                        return
                    }
                    let html = String(data: data!, encoding: .utf8)!
                    do {
                        let doc: Document = try SwiftSoup.parse(html)
                        let features = try doc.getElementById("quote-header-info")
                        let one = try features?.getElementsByClass("Whs(nw)").first()?.getElementsByClass("Trsdu(0.3s) Fw(b) Fz(36px) Mb(-4px) D(b)").text() ?? "0"
                        let two = try features?.select("span")
                        let news1 = try two?[3].text() ?? "+0.00"
                        let news2 = try two?[4].text() ?? "(+0.00%)"
                        let date = try features?.getElementById("quote-market-notice")?.select("span").text().split(separator: " ")[2].description ?? ""
                        self.result.append(.init(code: item, price: Double(one)?.convertToCurrency(true) ?? "R$ 0,0", variacao: news1.description, percent: news2.description, dateLastUpdate: date))
                        
                        if self.result.count == fiis.count {
                            self.result.sort(by: {$0.code < $1.code})
                            complete(true)
                        }
                        
                    } catch Exception.Error(type: let type, Message: let message) {
                        print("Erro aqui: \(type) / \(message)")
                        
                    } catch {
                        print("erro")
                    }
                }
                taskUm.resume()
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
        let value = "\(result[indexPath.row].price)    \(result[indexPath.row].variacao) \(result[indexPath.row].percent)"
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
