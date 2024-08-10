//
//  ViewController.swift
//  RendimentoComFII
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

protocol FIIDisplayLogic {
    func displaySuccess(_ fii: FIIModel.Fetch.FII)
    func displayError(_ message: String!)
    func setLastReport(_ url: String)
}


class FIIViewController: UIViewController, FIIDisplayLogic {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var viewHeader: NavigationBarHeaderView!
    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var imgFii: UIImageView!
    @IBOutlet var collectionLabelDaily: [UILabel]!
    @IBOutlet var collectionLabelSimulator: [UILabel]!
    @IBOutlet var collectionLabelTitle: [UILabel]!
    @IBOutlet var collectionLabelValue: [UILabel]!
    @IBOutlet var collectionView: [UIView]!
    @IBOutlet var collectionButton: [UIButton]!
    @IBOutlet weak var stackSocialNetwork: UIStackView!
    @IBOutlet weak var collectionPublication: UICollectionView!
    @IBOutlet weak var stackPublication: UIStackView!
    @IBOutlet weak var pagePublication: UIPageControl!
    @IBOutlet weak var lbIFIX: UILabel!
    @IBOutlet weak var viewSelic: UIView!
    @IBOutlet weak var lbSelicTitle: UILabel!
    @IBOutlet weak var lbSelicValue: UILabel!
    
    let listIcon = [UIImage(named: "instagram48"),
                    UIImage(named: "facebook48"),
                    UIImage(named: "whatsapp48"),
                    UIImage(named: "telegram48"),
                    UIImage(named: "twitter48"),
                    UIImage(named: "linkedin48")]
    
    var obj: FIIModel.Fetch.FII?
    var urlComments = "https://www.clubefii.com.br/fiis/code#comentarios"
    var isError = false
    var newsUrl: String?
    var currentSlide = 0
    var listNews = [FiisNews]()
    var reportUrl: String?
    
    var interactor: FIIBusinessLogic?
    var router: (NSObjectProtocol & FIIRoutingLogic & FIIDataPassing)?
    
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
        let interactor = FIIInteractor()
        let presenter = FIIPresenter()
        let router = FIIRouter()
        
        self.interactor = interactor
        self.router = router
        interactor.presenter = presenter
        presenter.viewController = self
        router.viewController = self
        router.dataStore = interactor
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ConfigureWalletFIIViewController
        let data = sender as! EditFii
        vc.insert = .fii
        vc.title = data.title
        vc.code = data.code
        vc.currentQuotas = data.quotas
        vc.btnInTheWallet = collectionButton[4]
        self.present(vc, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.getFii()
        setupLayout()
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isError {
            _ = self.alertView(type: .error, message: "Not Found").delegate = self
        }
    }
    
    private func setupLayout() {
        viewHeader.delegate = self
        viewHeader.setTitleHeader(name: NSLocalizedString("real_estate_fund", comment: ""))
        
        collectionPublication.delegate = self
        collectionPublication.dataSource = self
        collectionPublication.isHidden = true
        pagePublication.isHidden = collectionPublication.isHidden
        
        contentView.backgroundColor = .systemGray6
        
        imgBackground.contentMode = .scaleAspectFill
        
        collectionLabelDaily.forEach({
            $0.textAlignment = .center
            $0.font = UIFont.boldSystemFont(ofSize: 16)
            $0.textColor = .white
            $0.numberOfLines = 1
            $0.adjustsFontSizeToFitWidth = true
            $0.minimumScaleFactor = 0.1
            switch $0 {
            case collectionLabelDaily[0]:
                $0.text = NSLocalizedString("opening", comment: "")
                
            case collectionLabelDaily[1]:
                $0.text = NSLocalizedString("variation", comment: "")
                
            case collectionLabelDaily[2]:
                $0.text = NSLocalizedString("minimum", comment: "")
                
            case collectionLabelDaily[3]:
                $0.text = NSLocalizedString("maximum", comment: "")
                
            default:
                break
            }
            $0.text = $0.text?.elementsEqual("#N/D") ?? false ? "-" : $0.text!
            
        })
        
        collectionView.forEach({
            $0.layer.cornerRadius = 8
            $0.backgroundColor = $0 == collectionView.first ? UIColor(named: "mainBlue") : .systemBackground
            $0.backgroundColor = $0 == collectionView.last ? UIColor(named: "mainBlue") : $0.backgroundColor
        })
        
        collectionLabelTitle.forEach({
            $0.font = UIFont.boldSystemFont(ofSize: 16)
            $0.numberOfLines = $0.isEqual(collectionLabelTitle[13]) ? 1 : 0
            $0.textAlignment = $0.isEqual(collectionLabelTitle[collectionLabelTitle.count-2]) ? .right : .left
            $0.adjustsFontSizeToFitWidth = true
            $0.minimumScaleFactor = 0.1
        })
        
        var earnings = collectionLabelValue[5].text?.convertCurrencyToDouble() ?? 0.0
        
        if earnings == .zero {
            var i = 12
            while i > .zero {
                if let temp = obj?.earnings?.first(where: { $0.key.elementsEqual(Month(rawValue: i)!.description().0) }),
                   let value = (temp.value["earnings"] as? String)?.convertCurrencyToDouble() {
                    if value > .zero {
                        earnings = value
                        i = .zero
                    } else {
                        i -= 1
                    }
                } else {
                    i -= 1
                }
            }
        }
        
        let salary = Double((UserDefaultKeys.basicSalary.getValue() as! [String:Int]).first?.value ?? 0)
        let data = Util.calculationToReceiveEarnings(to: .init(targetValue: salary, priceCurrent: collectionLabelValue[3].text?.convertCurrencyToDouble() ?? 0.0, currentMonthEarnings: earnings, valueWithSymbol: true))
        
        let magicNumber = Util.calculationToReceiveEarnings(to: .init(targetValue: collectionLabelValue[3].text?.convertCurrencyToDouble()
                                                                      , priceCurrent: collectionLabelValue[3].text!.convertCurrencyToDouble()
                                                                      , currentMonthEarnings: earnings == .zero ? 0.01 : earnings
                                                                      , valueWithSymbol: true))
        
        collectionLabelSimulator.forEach({
            $0.font = UIFont.boldSystemFont(ofSize: 16)
            $0.numberOfLines = 0
            $0.textColor = .white
            switch $0 {
            case collectionLabelSimulator.first:
                $0.text = NSLocalizedString("target_value", comment: "").replacingOccurrences(of: "fii", with: "\(obj?.code ?? "FII")").replacingOccurrences(of: "R$", with: "\(salary.convertToCurrency(true))")
                
            case collectionLabelSimulator[1]:
                $0.text = NSLocalizedString("quantity_quotas", comment: "").replacingOccurrences(of: "9999", with: "\(data.totalQuotas)")
                
            case collectionLabelSimulator[2]:
                $0.text = NSLocalizedString("estimated_value", comment: "").replacingOccurrences(of: "R$", with:"\(data.estimatedValue)")
                
            case collectionLabelSimulator.last:
                $0.text = NSLocalizedString("magic_number", comment: "").replacingOccurrences(of: "FII", with:"\(obj?.code ?? "FII")").replacingOccurrences(of: "9999", with:"\(magicNumber.totalQuotas)").replacingOccurrences(of: "R$", with:"\(magicNumber.estimatedValue)")
                
            default:
                break
            }
        })
        
        collectionLabelTitle[0].font = UIFont.boldSystemFont(ofSize: 24)
        collectionLabelTitle[0].numberOfLines = 4
        collectionLabelTitle[0].minimumScaleFactor = 0.1
        collectionLabelTitle[0].adjustsFontSizeToFitWidth = true
        collectionLabelTitle[0].textColor = .white
        
        collectionLabelTitle[1].text = NSLocalizedString("segment", comment: "")
        
        collectionLabelTitle[2].text = NSLocalizedString("dy", comment: "")
        
        collectionLabelTitle[3].text = "P/VP"
        
        collectionLabelTitle[4].text = NSLocalizedString("current_price", comment: "")
        
        collectionLabelTitle[5].text = "\(NSLocalizedString("agio", comment: "")) / \(NSLocalizedString("discount", comment: ""))"
        
        collectionLabelTitle[6].font = UIFont.boldSystemFont(ofSize: 24)
        collectionLabelTitle[6].text = NSLocalizedString(Month.current.description().0, comment: "")
        
        collectionLabelTitle[7].text = NSLocalizedString("earnings", comment: "")
        
        collectionLabelTitle[8].text = NSLocalizedString("income", comment: "")
        
        collectionLabelTitle[9].text = NSLocalizedString("date_with", comment: "")
        
        collectionLabelTitle[10].text = NSLocalizedString("pay_day", comment: "")
        
        collectionLabelTitle[11].text = NSLocalizedString("phone", comment: "")
        
        collectionLabelTitle[12].text = NSLocalizedString("administrator", comment: "")
        
        collectionLabelTitle[13].text = collectionLabelValue[8].text!.isGreaterCurrentDate() ? !collectionLabelValue[5].text!.elementsEqual(NSLocalizedString("uninformed", comment: "")) ? NSLocalizedString("awaiting_payment", comment: "") : NSLocalizedString("waiting_announcement", comment: "") : NSLocalizedString("paid", comment: "")
        
        collectionLabelTitle[13].textColor = collectionLabelValue[8].text!.isGreaterCurrentDate() ? .gray : .systemGreen
        
        collectionLabelTitle.last?.text = NSLocalizedString("report", comment: "")
        
        collectionLabelValue.forEach({
            $0.textAlignment = .right
            $0.font = UIFont.boldSystemFont(ofSize: 16)
            $0.textColor = $0 == collectionLabelValue[3] ? UIColor.variationColor(to: collectionLabelDaily[5].text) : .gray
            $0.textColor = $0 == collectionLabelValue[4] ? UIColor.variationColor(to: collectionLabelValue[4].text, inverse: true) : $0.textColor
            $0.adjustsFontSizeToFitWidth = true
            $0.minimumScaleFactor = 0.1
            $0.numberOfLines = 1
        })
        
        for i in 0..<stackSocialNetwork.arrangedSubviews.count {
            (stackSocialNetwork.arrangedSubviews[i] as? UIButton)?.setupDefault(50)
            (stackSocialNetwork.arrangedSubviews[i] as? UIButton)?.setImage(listIcon[i], for: .normal)
        }
        
        pagePublication.currentPage = 0
        pagePublication.isUserInteractionEnabled = false
        
        viewSelic.layer.cornerRadius = (collectionView.first?.layer.cornerRadius)!
        viewSelic.backgroundColor = collectionView.first?.backgroundColor
        viewSelic.alpha = 0
        viewSelic.isHidden = false
        
        lbSelicTitle.textAlignment = collectionLabelDaily.first!.textAlignment
        lbSelicTitle.font = collectionLabelDaily.first!.font
        lbSelicTitle.textColor = collectionLabelDaily.first!.textColor
        lbSelicTitle.numberOfLines = collectionLabelDaily.first!.numberOfLines
        lbSelicTitle.adjustsFontSizeToFitWidth = collectionLabelDaily.first!.adjustsFontSizeToFitWidth
        lbSelicTitle.minimumScaleFactor = collectionLabelDaily.first!.minimumScaleFactor
        lbSelicTitle.text = NSLocalizedString("selic_title", comment: "")
        //"\(NSLocalizedString("selic_title", comment: "")) \(InitializationModel.dataIndexes.selic?.annualGoal.year ?? "0,0%")"
        
        lbSelicValue.textAlignment = collectionLabelDaily.first!.textAlignment
        lbSelicValue.font = collectionLabelDaily.first!.font
        lbSelicValue.textColor = collectionLabelDaily.first!.textColor
        lbSelicValue.numberOfLines = collectionLabelDaily.first!.numberOfLines
        lbSelicValue.adjustsFontSizeToFitWidth = collectionLabelDaily.first!.adjustsFontSizeToFitWidth
        lbSelicValue.minimumScaleFactor = collectionLabelDaily.first!.minimumScaleFactor
        lbSelicValue.text = InitializationModel.dataIndexes.selic?.annualGoal.value
        
    }
    
    
    private func showPublications() {
        //lista com todas as noticias
        HomeModel.listAllPublication.forEach({
            if $0.title!.uppercased().contains(self.obj!.code.uppercased()) {
                self.listNews.append($0)
            }
        })
        //lista com as noticias do dia
        NewsletterModel.listAllNews.forEach({ news in
            if news.title!.uppercased().contains(self.obj!.code.uppercased()), self.listNews.first(where: {$0.title!.elementsEqual(news.title!)}) == nil {
                self.listNews.append(.init(siteName: news.siteName, image: news.image, date: news.date, href: news.href, title: news.title))
            }
        })
        
        if listNews.isEmpty {
            collectionPublication.removeFromSuperview()
        } else {
            let listTemp = listNews
            listNews.removeAll()
            let limit = listTemp.count > 10 ? 10 : listTemp.count
            for i in 0..<limit {
                listNews.append(listTemp[i])
            }
            DispatchQueue.main.async {
                self.pagePublication.numberOfPages = self.listNews.count
                self.currentSlide = 0
                self.collectionPublication.reloadData()
                self.collectionPublication.isHidden = !self.collectionPublication.isHidden
                self.pagePublication.isHidden = self.collectionPublication.isHidden
                Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.nextNews), userInfo: nil, repeats: true)
            }
        }
    }
    
    @objc func nextNews() {
        currentSlide = currentSlide < (listNews.count-1) ? currentSlide+1 : 0
        collectionPublication.scrollToItem(at: IndexPath(item: currentSlide, section: 0), at: .right, animated: true)
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
    
    func displaySuccess(_ fii: FIIModel.Fetch.FII) {
        obj = fii
        
        lbIFIX.isHidden = !(obj?.isIFIX ?? false)
        let img = UIImage(named: fii.segment?.lowercased() ?? "outros")
        imgBackground.image = img == nil ? UIImage(named: "outros") : img
        
        imgFii.addText(fii.code)
        
        collectionLabelTitle[0].text = fii.socialReason
        
        collectionLabelValue[0].text = NSLocalizedString("\(fii.segment ?? "undefined")", comment: "")
        
        collectionLabelValue[1].text = fii.dividendYield ?? "0,00%"
        
        collectionLabelValue[2].text = String(fii.pvp ?? 0.0).prefix(5).replacingOccurrences(of: ".", with: ",")
        collectionLabelValue[2].text = (fii.pvp?.isNaN ?? true || fii.pvp?.isInfinite ?? true) ? "0,0" : collectionLabelValue[2].text
        
        collectionLabelValue[3].text = fii.price ?? "R$ 0,0"
        
        let calc = (fii.calcAgio(atual: Double(fii.price?.replacingOccurrences(of: "R$ ", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: ",", with: ".") ?? "0.0") ?? 0.0, patrimo: fii.equityValuePerShare ?? 0.0))
        collectionLabelValue[4].text = (calc.isNaN || calc.isInfinite) ? "0,0%" : "\(String(format: "%.3f", calc))%".replacingOccurrences(of: ".", with: ",")   //"\(String(calc).prefix(6).replacingOccurrences(of: ".", with: ","))%"
        collectionLabelValue[4].textColor = UIColor.variationColor(to: collectionLabelValue[4].text)
        
        collectionLabelValue[9].text = fii.phone ?? "(99) 9999-9999)"
        collectionLabelValue[9].text = collectionLabelValue[9].text!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "(99) 9999-9999)" : collectionLabelValue[9].text
        
        let monthCurrent = obj?.earnings?.first(where: {$0.key.elementsEqual(Month.current.description().0)})
        collectionLabelValue[5].text = (monthCurrent?.value["earnings"] as? String)?.convertCurrencyToDouble().convertToCurrency(true) ?? NSLocalizedString("uninformed", comment: "")
        
        collectionLabelValue[5].text = "R$ \(String(format: "%.4f", (monthCurrent?.value["earnings"] as? String ?? "").convertCurrencyToDouble()).replacingOccurrences(of: ".", with: ","))"
        
        let value = Double((obj?.getIncome(earnings: collectionLabelValue[5].text, price: monthCurrent?.value["price_date_with"] as? String)) ?? "0.0")
        var f: Double?
        if value!.isNaN || value!.isInfinite {
            f = 0.0
        } else {
            f = value
        }
        collectionLabelValue[6].text = "\(String(format: "%.3f", f!))%".replacingOccurrences(of: ".", with: ",")
        
        collectionLabelValue[7].text = monthCurrent?.value["date_with"] as? String ?? NSLocalizedString("uninformed", comment: "")
        
        collectionLabelValue[8].text = monthCurrent?.value["payment_date"] as? String ?? NSLocalizedString("uninformed", comment: "")
        
        collectionButton[0].setTitle(NSLocalizedString("historic_btn", comment: ""), for: .normal)
        //        kcollectionButton[0].isEnabled = false
        collectionButton[1].setTitle("\(NSLocalizedString("comment", comment: ""))\(fii.code!)", for: .normal)
        collectionButton[2].tintColor = .gray
        collectionButton[2].setTitle(NSLocalizedString("access", comment: ""), for: .normal)
        collectionButton[2].isEnabled = fii.site?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true ? false : true
        collectionButton[2].setTitle(!collectionButton[2].isEnabled ? NSLocalizedString("uninformed", comment: "") : collectionButton[2].currentTitle, for: .normal)
        collectionButton[3].setTitle(NSLocalizedString("simulations", comment: ""), for: .normal)
        collectionButton[3].isHidden = true
        collectionButton[4].backgroundColor = .white
        collectionButton[4].layer.cornerRadius = 8
        collectionButton[4].layer.shadowOffset = CGSize(width: 3, height: 3)
        collectionButton[4].layer.shadowOpacity = 0.3
        collectionButton[5].isEnabled = false
        collectionButton[5].setTitle(NSLocalizedString("searching", comment: ""), for: .normal)
        collectionButton[5].tintColor = .gray
        
        if Util.userDefaultForWallet(action: .read, code: fii.code!).code.isEmpty {
            collectionButton[4].setTitle(NSLocalizedString("add_wallet", comment: ""), for: .normal)
            collectionButton[4].setImage(UIImage(systemName: "star"), for: .normal)
            collectionButton[4].tintColor = UIColor(named: AlertType.info.rawValue)
            collectionButton[4].layer.shadowColor = collectionButton[4].tintColor?.cgColor
        } else {
            collectionButton[4].setTitle(NSLocalizedString("remove_wallet", comment: ""), for: .normal)
            collectionButton[4].setImage(UIImage(systemName: "star.fill"), for: .normal)
            collectionButton[4].tintColor = UIColor(named: AlertType.warning.rawValue)
            collectionButton[4].layer.shadowColor = collectionButton[4].tintColor?.cgColor
        }
        
        urlComments = urlComments.replacingOccurrences(of: "code", with: fii.code!)
        
        for i in 0..<stackSocialNetwork.arrangedSubviews.count {
            let key = SocialNetwork.allCases[i].rawValue
            if fii.social_network == nil {
                stackSocialNetwork.arrangedSubviews[i].isHidden = true
            } else if key == fii.social_network?.first(where: {$0.key == SocialNetwork.allCases[i].rawValue})?.key
                        && fii.social_network!.first(where: {$0.key == SocialNetwork.allCases[i].rawValue})!.value.contains("google.com") {
                stackSocialNetwork.arrangedSubviews[i].isHidden = true
            }
            
        }
        
        quoteList.forEach({
            if $0.code.elementsEqual(fii.code!) {
                collectionLabelDaily[4].text = $0.opening
                collectionLabelDaily[5].text = $0.variation
                collectionLabelDaily[6].text = $0.minimum
                collectionLabelDaily[7].text = $0.maximum
                collectionLabelValue[3].text = $0.currentPrice
                
                $0.closing.forEach {c in print(c) }
            }
        })
        
        showPublications()
        
    }
    
    func displayError(_ message: String!) {
        contentView.alpha = 0
        isError = true
    }
    
    func setLastReport(_ url: String) {
        DispatchQueue.main.async {
            self.collectionButton[5].isEnabled = url.isEmpty ? false : true
            self.collectionButton[5].setTitle(NSLocalizedString(url.isEmpty ? "unavailable" : "access", comment: ""), for: .normal)
            self.reportUrl = url
        }
    }
    
    @IBAction func didTapButton(_ sender: UIButton) {
        switch sender {
        case collectionButton[0]:
            router?.routeTosegueHistoricWithSegue(segue: nil)
            
        case collectionButton[1]:
            router?.routeTosegueCommentsWithSegue(segue: nil)
            
        case collectionButton[2]:
            guard let url = obj?.site, !url.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
            "https://\(url)".openUrl()
            
        case collectionButton[3]:
            let vc = storyboard?.instantiateViewController(withIdentifier: "simulator") as! SimulatorViewController
            vc.obj = obj
            self.segueTo(destination: vc)
            
        case collectionButton[4]:
            if Util.userDefaultForWallet(action: .read, code: obj?.code ?? "").code.isEmpty {
                sender.didTapAddToWallet(codeFii: obj!.code, action: .create)
                performSegue(withIdentifier: "segue", sender: EditFii.init(title: NSLocalizedString("title_config_wallet_add", comment: ""), code: obj!.code, quotas: ""))
            } else {
                sender.didTapAddToWallet(codeFii: obj!.code, action: .delete)
            }
            
        case collectionButton[5]:
            guard let url = reportUrl else { return }
            url.openUrl()
            
        default:
            break
        }
    }
    
    @IBAction func didTapSocialNetwork(_ sender: UIButton) {
        for i in 0..<stackSocialNetwork.arrangedSubviews.count {
            if (stackSocialNetwork.arrangedSubviews[i] as? UIButton) == sender {
                let url = (obj?.social_network!.first(where: {$0.key == SocialNetwork.allCases[i].rawValue})!.value)!
                url.openUrl()
            }
        }
    }
    
    @IBAction func didTapShowSelic(_ sender: Any) {
        UIView.animate(withDuration: 1, delay: 0) {
            self.viewSelic.alpha = 1
        } completion: { _ in
            Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
                UIView.animate(withDuration: 0.5, delay: 0) {
                    self.viewSelic.alpha = 0
                }
            }
        }
    }
    
}


extension FIIViewController: ActionButtonAlertDelegate {
    func close() {
        dismiss(animated: false) {
            Util.hideAlertMessage()
            self.newsUrl?.openUrl()
        }
    }
}


extension FIIViewController: NavigationBarHeaderDelegate {
    func didTapButtonBack(_ sender: UIButton) {
        self.dismissWith()
    }
    
    
}


extension FIIViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listNews.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellPublication", for: indexPath) as! PublicationCollectionViewCell
        cell.setPublication(pub: listNews[indexPath.row])
        
        return cell
    }
    
}


extension FIIViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
}


extension FIIViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //        let cellCurrent = cell as! MyVideosCollectionViewCell
        //        if indexPath.row == positionIndexPathCollection?.row ?? 0 {
        //            cellCurrent.pausePressed()
        //            collectionView.selectItem(at: positionIndexPathCollection, animated: false, scrollPosition: [])
        //        } else {
        //            cellCurrent.playPressed()
        //        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! PublicationCollectionViewCell
        newsUrl = cell.urlSite
        if UserDefaults.standard.bool(forKey: UserDefaultKeys.hideNewsAlert.rawValue) {
            newsUrl?.openUrl()
        } else {
            alertView(type: .info, message: NSLocalizedString("da_news", comment: "")).delegate = self
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        //        let cell = collectionView.cellForItem(at: indexPath) as? MyVideosCollectionViewCell
        //        cell?.playPressed()
    }
}


extension FIIViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pagePublication.currentPage = Int(pageIndex)
        currentSlide = pagePublication.currentPage
    }
    
}
