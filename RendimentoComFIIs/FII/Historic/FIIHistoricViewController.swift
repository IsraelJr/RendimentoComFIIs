//
//  FIIHistoricViewController.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 05/06/22.
//

import UIKit

protocol FIIHistoricDisplayLogic {
    func showHistoric(_ earnings: FIIHistoricModel.Fetch.FIIHistoric?, _ code: String)
}

class FIIHistoricViewController: UIViewController, FIIHistoricDisplayLogic {
    
    @IBOutlet weak var viewHeader: NavigationBarHeaderView!
    @IBOutlet weak var tableHistoric: UITableView!
    
    var code = ""
    var listEarnings: FIIHistoricModel.Fetch.FIIHistoric?
    var listCurrentYear = [(String,Double)]()
    var yearSelected = ""
    
    var interactor: FIIHistoricBusinessLogic?
    var router: (NSObjectProtocol & FIIHistoricRoutingLogic & FIIHistoricDataPassing)?
    
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
        let interactor = FIIHistoricInteractor()
        let presenter = FIIHistoricPresenter()
        let router = FIIHistoricRouter()
        
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
        setupLayout()
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
    }
    
    
    // MARK: - Navigation
    
    private func setupLayout() {
        viewHeader.setTitleHeader(name: NSLocalizedString("historic", comment: ""))
        viewHeader.delegate = self
        
        tableHistoric.delegate = self
        tableHistoric.dataSource = self
        tableHistoric.backgroundColor = .clear
        
        interactor?.getHistory()
    }
    
    private func totalEarningsByYear(_ year: String) -> Double {
        var total: Double = 0.0
        listEarnings?.earnings?.forEach({ item in
            let x = item.first(where: {$0.key.elementsEqual(year)})?.value as? [String:Any]
            if !(x?.isEmpty ?? true) {
                Month.allCases.forEach({ month in
                    if month != .current {
                        let data = (x?.first(where: {$0.key.elementsEqual(month.description().0)})?.value as? [String:String])
                        let value = data?.first(where: {$0.key.elementsEqual("earnings")})?.value.convertCurrencyToDouble()
                        value ?? 0.0 > 0.0 ? total += value ?? 0.0 : nil
                    }
                })
            }
        })
        
        return total
    }
    
    private func setList() {
        listCurrentYear.removeAll()
        listEarnings?.earnings?.forEach({ item in
            let x = item.first(where: {$0.key.elementsEqual(yearSelected)})?.value as? [String:Any]
            if !(x?.isEmpty ?? true) {
                Month.allCases.forEach({ month in
                    if month != .current {
                        let v = ((x?.first(where: {$0.key.elementsEqual(month.description().0)})?.value as? [String:String])?.first(where: {$0.key.elementsEqual("earnings")})?.value)?.convertCurrencyToDouble()
                        v ??  0.0 > 0.0 ? listCurrentYear.append((month.description().0,v!)) : nil
                    }
                })
            }
        })
        DispatchQueue.main.async {
            self.tableHistoric.reloadData()
        }
    }
    
    private func calculateYield() -> [(String,String)] {
        var listDy = [(String,String)]()
//        var total: Double = 0.0
        listEarnings?.earnings?.forEach({ item in
            let x = item.first(where: {$0.key.elementsEqual(yearSelected)})?.value as? [String:Any]
            if !(x?.isEmpty ?? true) {
                Month.allCases.forEach({ month in
                    if month != .current {
                        let data = (x?.first(where: {$0.key.elementsEqual(month.description().0)})?.value as? [String:String])
//                        let value = data?.first(where: {$0.key.elementsEqual("earnings")})?.value.convertCurrencyToDouble()
//                        value ?? 0.0 > 0.0 ? total += value ?? 0.0 : nil
                        var yield = Double(FIIModel.Fetch.FII().getIncome(earnings: data?.first(where: {$0.key.elementsEqual("earnings")})?.value, price: data?.first(where: {$0.key.elementsEqual("price_date_with")})?.value)) ?? 0
//                        var value: Double?
//                        if yield.isNaN || yield.isInfinite {
//                            value = 0.0
//                        } else {
//                            value = w
//                        }
                        (yield.isNaN || yield.isInfinite) ? yield = 0.0 : nil
                        listDy.append((month.description().0,"\(String(format: "%.3f", yield))%".replacingOccurrences(of: ".", with: ",")))
                    }
                })
            }
        })
        return listDy
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
    
    func showHistoric(_ earnings: FIIHistoricModel.Fetch.FIIHistoric?, _ code: String) {
        guard let _ = earnings else { return }
        listEarnings = earnings
        self.code = code
        tableHistoric.reloadData()
    }
}


extension FIIHistoricViewController: NavigationBarHeaderDelegate {
    func didTapButtonBack(_ sender: UIButton) {
        dismissWith()
    }
}


extension FIIHistoricViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listCurrentYear.isEmpty ? listEarnings?.earnings?.count ?? 0 : listCurrentYear.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FIIHistoricTableViewCell
        if listCurrentYear.count > 0 {
            let yield = calculateYield().first(where: {$0.0.elementsEqual(listCurrentYear[indexPath.row].0)})?.1 ?? "0,0%"
            cell.setData(yearSelected,(listCurrentYear[indexPath.row].0, listCurrentYear[indexPath.row].1, yield))
            cell.animateTransition(indexPath.row)
        } else {
            let year = listEarnings?.earnings?[indexPath.row].first?.key ?? ""
            cell.setYear((year, totalEarningsByYear(year)))
            yearSelected.isEmpty ? nil : cell.animateTransition(indexPath.row)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var total: Double = 0.0
        var text = NSLocalizedString("accumulated", comment: "")
        if listCurrentYear.count > 0 {
            listCurrentYear.forEach({
                total += $0.1
            })
            text = "\(text.replacingOccurrences(of: ":", with: "")) \(yearSelected): \(total.convertToCurrency(true))"
        } else {
            listEarnings?.earnings?.forEach({ item in
                total += totalEarningsByYear(item.first?.key ?? "")
            })
            text = "\(text) \(total.convertToCurrency(true))"
        }
        return text
    }
    
}


extension FIIHistoricViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! FIIHistoricTableViewCell
        let option = (cell.img.subviews[0] as! UILabel).text!
        if option.contains("2") {
            yearSelected = option
            setList()
        } else {
            listCurrentYear.removeAll()
        }
        tableView.reloadData()
    }
}
