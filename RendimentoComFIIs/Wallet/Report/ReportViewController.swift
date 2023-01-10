//
//  ViewController.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

protocol ReportDisplayLogic {
    func showData()
}


class ReportViewController: UIViewController, ReportDisplayLogic {
    
    @IBOutlet weak var viewHeader: NavigationBarHeaderView!
    @IBOutlet weak var labelPatrimony: UILabel!
    @IBOutlet weak var labelValuePatrimonyValue: UILabel!
    @IBOutlet var collectionViewMain: [UIView]!
    @IBOutlet var collectionViewSub: [UIView]!
    @IBOutlet var collectionImageSubView: [UIImageView]!
    @IBOutlet var collectionLabelValue: [UILabel]!
    
    let listTextAlignmentRight = [2,5,9,12,16,19,23,26,30,33,37,40]
    let listFontBold16 = [0,2,5,7,9,12,14,16,19,21,23,26,28,30,33,35,37,40]
    
    var interactor: ReportBusinessLogic?
    var router: (NSObjectProtocol & ReportRoutingLogic & ReportDataPassing)?
    
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
        let interactor = ReportInteractor()
        let presenter = ReportPresenter()
        let router = ReportRouter()
        
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
        showData()
        showPatrimony(ReportModel.patrimony)
        
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
    
    private func setupLayout() {
        viewHeader.setTitleHeader(name: NSLocalizedString("report", comment: ""))
        viewHeader.delegate = self
        
        labelPatrimony.text = NSLocalizedString("patrimony", comment: "")
        labelPatrimony.font = UIFont.boldSystemFont(ofSize: 24)
        labelPatrimony.adjustsFontSizeToFitWidth = true
        labelPatrimony.minimumScaleFactor = 0.1
        
        labelValuePatrimonyValue.text = 0.convertToCurrency(true)
        labelValuePatrimonyValue.font = labelPatrimony.font
        labelValuePatrimonyValue.textAlignment = .right
        labelValuePatrimonyValue.adjustsFontSizeToFitWidth = true
        labelValuePatrimonyValue.minimumScaleFactor = 0.1
        
        collectionViewMain.forEach { view in
            view.backgroundColor = .clear
        }
        
        collectionViewSub.forEach { view in
            view.layer.cornerRadius = 4
            view.backgroundColor = .clear
            view.clipsToBounds = true
        }
        
        for i in 0..<collectionImageSubView.count {
            collectionImageSubView[i].contentMode = .scaleAspectFill
            collectionImageSubView[i].image = i%2 == 0 ? UIImage(named: "background_blue") : UIImage(named: "background_red")
        }
        
        listTextAlignmentRight.forEach { index in
            collectionLabelValue[index].textAlignment = .right
        }
        
        collectionLabelValue.forEach( { $0.font = UIFont.systemFont(ofSize: 12) } )
        
        listFontBold16.forEach { index in
            collectionLabelValue[index].font = UIFont.boldSystemFont(ofSize: 16)
        }
        
        collectionLabelValue.forEach {
            $0.adjustsFontSizeToFitWidth = true
            $0.minimumScaleFactor = 0.1
        }
        
        //Titles
        collectionLabelValue[00].text = "\(NSLocalizedString("report_patrimony", comment: ""))"
        collectionLabelValue[07].text = "\(NSLocalizedString("report_dividend", comment: ""))"
        collectionLabelValue[14].text?.removeAll()
        collectionLabelValue[21].text = "\(NSLocalizedString("report_fiis", comment: ""))"
        collectionLabelValue[28].text?.removeAll()
        collectionLabelValue[35].text?.removeAll()
        
        //Sub Title
        collectionLabelValue[01].text = "\(NSLocalizedString("variation_year", comment: "")) \(Util.currentYear)"
        collectionLabelValue[04].text = NSLocalizedString("historic_variation", comment: "")
        collectionLabelValue[08].text = "\(NSLocalizedString("best", comment: ""))\(Util.currentYear)"
        collectionLabelValue[11].text = "\(NSLocalizedString("worst", comment: ""))\(Util.currentYear)"
        collectionLabelValue[15].text = NSLocalizedString("best_historic", comment: "")
        collectionLabelValue[18].text = NSLocalizedString("worst_historic", comment: "")
        collectionLabelValue[22].text = "\(NSLocalizedString("best_fii", comment: ""))"
        collectionLabelValue[25].text = "\(NSLocalizedString("worst_fii", comment: ""))"
        
        //Period
        collectionLabelValue[03].text?.removeAll()
        collectionLabelValue[06].text?.removeAll()
        
        collectionLabelValue[29].text = "Maior exposição por FII"
        collectionLabelValue[32].text = "Menor exposição por FII"
        
        collectionLabelValue[36].text = "Maior exposição por segmento"
        collectionLabelValue[39].text = "Menor exposição por segmento"
        
    }
    
    private func validar() {
        let month = NSLocalizedString(NSLocalizedString(Month.current.description().0, comment: ""), comment: "")
        collectionLabelValue[10].text?.isEmpty ?? true ? collectionLabelValue[10].text = month : nil
        collectionLabelValue[13].text?.isEmpty ?? true ? collectionLabelValue[13].text = month : nil
        collectionLabelValue[17].text?.replacingOccurrences(of: "/", with: "").isEmpty ?? true ? collectionLabelValue[16].text = "\(month) / \(Util.currentYear)" : nil
        collectionLabelValue[20].text?.replacingOccurrences(of: "/", with: "").isEmpty ?? true ? collectionLabelValue[19].text = "\(month) / \(Util.currentYear)" : nil
        
    }
    
    private func percentageChange(newValue: Double?, oldValue: Double?) -> Double {
        guard let new = newValue, let old = oldValue, new > 0, old > 0 else { return 0 }
        return (((new - old) / old) * 100)
    }
    
    
    func showData() {
        var bestCurrent = ("","",0.0)
        var worstCurrent = ("","",0.0)
        var listHistoric = [(String,String,Double)]()
        
        WalletViewController.wallet?.annualEarnings?.forEach({ item in
            if item.key.elementsEqual(Util.currentYear) {
                let list = (item.value as? [String:Double])?.sorted(by: { $0.value > $1.value })
                bestCurrent = (Util.currentYear, list?.first?.key ?? "", list?.first?.value ?? 0)
                worstCurrent = (Util.currentYear, list?.last?.key ?? "", list?.last?.value ?? 0)
            } else {
                let list = item.value as? [String:Double]
                list?.forEach({
                    listHistoric.append((item.key, $0.key, $0.value))
                })
            }
        })
        
        listHistoric += [bestCurrent]
        listHistoric += [worstCurrent]
        let listComplet = listHistoric.sorted(by: { $0.2 > $1.2 })
        var listYeld = [FIIModel.Fetch.FII]()
        var total = 0.0
        WalletViewController.wallet?.wallet?.forEach({ item in
            if item.values.first ?? 0 > 0 {
                let price = (quoteList.first(where: {$0.code.elementsEqual(item.first?.key ?? "")})?.currentPrice ?? "0").convertCurrencyToDouble()
                let fii = ListFii.listFiis.first(where: { $0.code.elementsEqual(item.keys.first!) })
                total += price * Double(item.values.first!)
                listYeld.append(fii!)
            }
        })
        listYeld = listYeld.sorted(by: { $0.dividendYield!.replacingOccurrences(of: "%", with: "").convertCurrencyToDouble() > $1.dividendYield!.replacingOccurrences(of: "%", with: "").convertCurrencyToDouble() })
        
        labelValuePatrimonyValue.text = total.convertToCurrency(true)
        
        collectionLabelValue[09].text = bestCurrent.2.convertToCurrency(true)
        collectionLabelValue[10].text = NSLocalizedString(bestCurrent.1, comment: "")
        collectionLabelValue[12].text = worstCurrent.2.convertToCurrency(true)
        collectionLabelValue[13].text = NSLocalizedString(worstCurrent.1, comment: "")
        
        collectionLabelValue[16].text = listComplet.first?.2.convertToCurrency(true)
        collectionLabelValue[17].text = "\(NSLocalizedString(listComplet.first?.1 ?? "", comment: "")) / \(listComplet.first?.0 ?? "")"
        collectionLabelValue[19].text = listComplet.last?.2.convertToCurrency(true)
        collectionLabelValue[20].text = "\(NSLocalizedString(listComplet.last?.1 ?? "", comment: "")) / \(listComplet.last?.0 ?? "")"
        
        collectionLabelValue[23].text = listYeld.first?.dividendYield ?? "0,0%"
        collectionLabelValue[24].text = listYeld.first?.code ?? ""
        collectionLabelValue[26].text = listYeld.last?.dividendYield ?? "0,0%"
        collectionLabelValue[27].text = listYeld.last?.code ?? ""
        
        validar()
    }
    
    func showPatrimony(_ list: ReportModel.Fetch.Report?) {
        DispatchQueue.main.async { [self] in
            var listValuesCurrentYear = [(String,Double)?]()
            var listPreviousYearValues = [(String,String,Double)?]()
            var tempCurrent = [Double]()
            var tempPrevious = tempCurrent
            
            list?.patrimony.forEach({ item in
//                item.key.forEach({ year in
                item.key.elementsEqual(Util.currentYear) ? item.value.forEach({ listValuesCurrentYear.append(($0.key, $0.value)) }) : item.value.forEach({ listPreviousYearValues.append((item.key, $0.key, $0.value)) })
//                })
            })
            
            if listValuesCurrentYear.count >= 1 {
                for i in 1...12 {
                    let val = listValuesCurrentYear.first(where: { $0!.0.elementsEqual(NSLocalizedString(i.description, comment: "")) }) as? (String,Double)
                    val != nil ? tempCurrent.append(val!.1) : nil
                }
            }
            
            if listPreviousYearValues.count >= 1 {
                for y in 2020...Int(Util.currentYear)! {
                    for i in 1...12 {
                        let val = listPreviousYearValues.first(where: { $0!.0.elementsEqual(y.description) && $0!.1.elementsEqual(NSLocalizedString(i.description, comment: "")) }) as? (String,String,Double)
                        val != nil ? tempPrevious.append(val!.2) : nil
                    }
                }
            }
            
            let valueCurrent = self.percentageChange(newValue: tempCurrent.last, oldValue: tempCurrent.first)
            collectionLabelValue[2].text = "\(String(format: "%.2f", valueCurrent))%"
            
            let valuePrevious = self.percentageChange(newValue: tempCurrent.last ?? tempPrevious.last, oldValue: tempPrevious.first)
            collectionLabelValue[5].text = "\(String(format: "%.2f", valuePrevious))%"
            
            let listRatioByFii = Util.calculatePortfolioRatioByFii()
            collectionLabelValue[30].text = listRatioByFii.first?.1 ?? ""
            collectionLabelValue[31].text = listRatioByFii.first?.0 ?? ""
            collectionLabelValue[33].text = listRatioByFii.last?.1 ?? ""
            collectionLabelValue[34].text = listRatioByFii.last?.0 ?? ""
            
            let listRatioBySegment = Util.calculatePortfolioRatioBySegment()
            collectionLabelValue[37].text = listRatioBySegment.first?.1
            collectionLabelValue[38].text = listRatioBySegment.first?.0
            collectionLabelValue[40].text = listRatioBySegment.last?.1
            collectionLabelValue[41].text = listRatioBySegment.last?.0
            
        }
    }
    
}

extension ReportViewController: NavigationBarHeaderDelegate {
    func didTapButtonBack(_ sender: UIButton) {
        dismissWith()
    }
}

