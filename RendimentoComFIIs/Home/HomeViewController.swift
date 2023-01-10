//
//  ViewController.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit
import GoogleMobileAds

protocol HomeDisplayLogic {
    func showPublications(_ pub: [FiisNews])
    //    func showTallAndShort(_ list: [[(String,String)]])
    func showTopics(_ show: Bool)
}


class HomeViewController: UIViewController, HomeDisplayLogic, GADFullScreenContentDelegate {
    
    @IBOutlet var collectionLabelTitle: [UILabel]!
    @IBOutlet var collectionLabelSubTitle: [UILabel]!
    @IBOutlet var collectionImageStatic: [UIImageView]!
    @IBOutlet var collectionButton: [UIButton]!
    @IBOutlet var collectionView: [UIView]!
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var viewIFIX: IndexIFIXView!
    @IBOutlet weak var viewNewMessageInbox: UIView?
    @IBOutlet weak var btnSeeNewMessage: UIButton!
    @IBOutlet weak var lbNewMessage: UILabel!
    @IBOutlet weak var collectionPublication: UICollectionView!
    @IBOutlet weak var lbLoadingNews: UILabel!
    @IBOutlet weak var pagePublication: UIPageControl!
    @IBOutlet weak var collectionTopic: UICollectionView!
    @IBOutlet weak var viewTopDY: UIView!
    @IBOutlet weak var collectionTopDY: UICollectionView!
    @IBOutlet weak var lbLoadingFiis: UILabel!
    @IBOutlet weak var buttonFilter: UIButton!
    @IBOutlet weak var btnConfigureNews: UIButton!
    @IBOutlet var collectionBarSide: [UIView]!
    @IBOutlet weak var viewLow: UIView!
    @IBOutlet weak var viewThought: UIView!
    @IBOutlet weak var viewBanner: GADBannerView!
    @IBOutlet weak var stackBanner: UIStackView!
    
    let allFiis = ListFii.allFiis()
    
    var newsUrl: String?
    var viewFilter = UIView()
    var typeSort: ListFii.SortFiis?
    var timer: Timer?
    var currentSlide = 0
    var countIFIX: Double = 0.0
    var arrayTemp = [Any]()
    var isExit = false
    
    var interactor: HomeBusinessLogic?
    var router: (NSObjectProtocol & HomeRoutingLogic & HomeDataPassing)?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
        interactor?.getPhrase()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        timer?.invalidate()
        setup()
        getTallAndShort()
        Timer.scheduledTimer(timeInterval: InitializationModel.customTimeInterval, target: self, selector: #selector(getTallAndShort), userInfo: nil, repeats: true)
    }
    
    // MARK: Setup
    
    private func setup() {
        let interactor = HomeInteractor()
        let presenter = HomePresenter()
        let router = HomeRouter()
        
        self.interactor = interactor
        self.router = router
        interactor.presenter = presenter
        presenter.viewController = self
        router.viewController = self
        router.dataStore = interactor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
            DispatchQueue.main.async {
                self.displayListFiis()
                self.lbLoadingFiis.isHidden = true
                self.lbLoadingFiis.text?.removeAll()
            }
        }
        interactor?.getItemsLibrary()
        setupLayout()
        showPhrase()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        hideAlertNewMessage()

        guard DataUser.vip != nil else { return }
        if -2...2 ~= DataUser.vip!, HomeModel.isVIPShow {
            HomeModel.isVIPShow = false
            showAlert(DataUser.vip! > 0 ? .warning : .info, DataUser.vip! > 0 ? NSLocalizedString("vip_finished", comment: "") : "\(NSLocalizedString("vip_will_finish", comment: "")) \(DataUser.vip! == 0 ? NSLocalizedString("today", comment: "") : "\(NSLocalizedString("in", comment: "")) \(DataUser.vip!) \(NSLocalizedString("days", comment: ""))".replacingOccurrences(of: "-", with: ""))!")
        }
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        showDataIFIX()
    }
    
    private func setupLayout() {
        viewContent.backgroundColor = .systemGray6
        
        collectionTopic.delegate = self
        collectionTopic.dataSource = self
        
        viewTopDY.layer.cornerRadius = 24
        viewTopDY.backgroundColor = .clear
        
        buttonFilter.setupDefault(50, "arrow.up.arrow.down.square")
        
        collectionPublication.delegate = self
        collectionPublication.dataSource = self
        
        lbLoadingNews.text = HomeModel.listPublication.isEmpty ? NSLocalizedString("loading_news", comment: "") : ""
        lbLoadingNews.numberOfLines = 6
        lbLoadingNews.adjustsFontSizeToFitWidth = true
        lbLoadingNews.minimumScaleFactor = 0.1
        lbLoadingNews.textAlignment = .center
        lbLoadingNews.font = UIFont.boldSystemFont(ofSize: 16)
        
        collectionTopDY.delegate = self
        collectionTopDY.dataSource = self
        collectionTopDY.backgroundColor = .clear
        
        lbLoadingFiis.isHidden = false
        lbLoadingFiis.text = HomeModel.tenRandomFiis?.isEmpty ?? true ? NSLocalizedString("loading_fiis", comment: "") : ""
        lbLoadingFiis.numberOfLines = 1
        lbLoadingFiis.textAlignment = .center
        lbLoadingFiis.font = UIFont.boldSystemFont(ofSize: 16)
        
        let viewFooter = view.createNavigationBarFooter(position: 0)
        viewFooter.delegate = self
        
        viewFilter.isHidden = true
        
        pagePublication.currentPage = 0
        pagePublication.isUserInteractionEnabled = false
        
        btnConfigureNews.setupDefault(btnConfigureNews.frame.width)
        btnConfigureNews.setImage(UIImage(named: "more20"), for: .normal)
        btnConfigureNews.backgroundColor = .white
        
        collectionBarSide.forEach({
            $0.backgroundColor = UIColor(named: "Border")
        })
        
        collectionLabelTitle.forEach({
            $0.font = UIFont.boldSystemFont(ofSize: 32)
            $0.numberOfLines = 3
            $0.adjustsFontSizeToFitWidth = true
            $0.minimumScaleFactor = 0.1
        })
        collectionLabelTitle[0].text = NSLocalizedString("real_estate_fund", comment: "")
        collectionLabelTitle[1].text = NSLocalizedString("high", comment: "")
        collectionLabelTitle[2].text = NSLocalizedString("low", comment: "")
        collectionLabelTitle[3].text = NSLocalizedString("thought", comment: "")
        
        collectionLabelSubTitle.forEach({
            $0.numberOfLines =  0
            $0.font = ($0 == collectionLabelSubTitle[2] || $0 == collectionLabelSubTitle[3]) ? $0.font : UIFont.boldSystemFont(ofSize: 24)
            $0.textAlignment = $0 == collectionLabelSubTitle[3] ? .right : .left
            $0.textColor = .white
            $0.lineBreakMode = .byWordWrapping
            $0.text = ""
            
            if $0 == collectionLabelSubTitle[2] {
                $0.numberOfLines = 8
                $0.textAlignment = .center
                $0.lineBreakMode = .byClipping
                $0.adjustsFontSizeToFitWidth = true
                $0.minimumScaleFactor = 0.1
            }
        })
        
        collectionImageStatic.forEach({
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = 16
        })
        
        collectionView.forEach({
            $0.layer.cornerRadius = 16
            $0.backgroundColor = .black
            $0.alpha = $0.isEqual(collectionView.last) ? 0.75 : 0.5
            $0.clipsToBounds = true
        })
        
        collectionButton.forEach({
            $0.tintColor = .white
            $0.setTitle(NSLocalizedString("searching", comment: ""), for: .normal)
            $0.layer.cornerRadius = 8
            $0.layer.backgroundColor = $0.restorationIdentifier?.elementsEqual("H") ?? false ? UIColor.systemGreen.cgColor : UIColor.systemRed.cgColor
        })
        
        viewLow.backgroundColor = .clear
        
        if true.description.elementsEqual(UserDefaults.standard.string(forKey: UserDefaultKeys.downloadNews.rawValue) ?? true.description) {
            HomeModel.listPublication.count == 0 ? interactor?.getPublications([.all]) : showPublications(HomeModel.listPublication)
        } else {
            HomeModel.listPublication.removeAll()
            collectionPublication.reloadData()
            lbLoadingNews.text = NSLocalizedString("download_news_manually", comment: "")
        }
        
        viewThought.backgroundColor = .clear
        collectionImageStatic.last!.image = UIImage(named: "pensamento")
        
        Ad.showBanner(viewBanner, self)
        UserDefaultKeys.vip.getValue() as! Bool ? stackBanner?.removeFromSuperview() : nil
        
        viewNewMessageInbox?.layer.cornerRadius = 16
        viewNewMessageInbox?.backgroundColor = .label
        lbNewMessage.font = UIFont.boldSystemFont(ofSize: 16)
        lbNewMessage.textAlignment = .center
        lbNewMessage.text = NSLocalizedString("new_message", comment: "")
        lbNewMessage.textColor = .systemBackground
        btnSeeNewMessage.setupDefault(35, "arrow.forward")
        btnSeeNewMessage.tintColor = lbNewMessage.textColor
        
        hideAlertNewMessage()
    }
    
    @objc private func getTallAndShort() {
        interactor?.getTallAndShort()
        showTallAndShort()
    }
    
    @objc func nextNews() {
        currentSlide = currentSlide < (HomeModel.listPublication.count-1) ? currentSlide+1 : 0
        collectionPublication.scrollToItem(at: IndexPath(item: currentSlide, section: 0), at: .right, animated: true)
    }
    
    @objc func closeViewFilter(_ sender: UIButton) {
        viewFilter.isHidden = true
        if sender.tag == 0 {
            typeSort = .highestPrice
        } else if sender.tag == 1 {
            typeSort = .lowestPrice
        } else {
            typeSort = .highestDY
        }
        displayListFiis()
    }
    
    private func setFii(_ fii: FIIModel.Fetch.FII) {
        interactor?.setFii(fii)
        router?.routeTosegueFIIWithSegue(segue: nil)
    }
    
    private func hideAlertNewMessage() {
        guard let view = viewNewMessageInbox else { return }
        (UserDefaultKeys.unread_message.getValue() as! Bool == false || InitializationModel.listMessagesReceived.count == 0) ? view.removeFromSuperview() : nil
    }
    
    func showDataIFIX() {
        guard let data = InitializationModel.dataIfix else { return }
        viewIFIX!.setData(ifix: data)
    }
    
    private func showAlert(_ type: AlertType, _ message: String!) {
        _ = self.alertView(type: type, message: message).delegate = self
    }
    
    func showTopics(_ show: Bool) {
        show ? arrayTemp = HomeModel.listItensLibrary : nil
        collectionTopic?.reloadData()
    }
    
    func displayListFiis() {
        if typeSort == .highestPrice || typeSort == .lowestPrice {
            HomeModel.tenRandomFiis = ListFii.tenPrices(typeSort: typeSort!)
        } else if typeSort == .highestDY || typeSort == .lowestDY {
            HomeModel.tenRandomFiis = ListFii.tenDy(typeSort: typeSort!)
        } else {
            HomeModel.tenRandomFiis = ListFii.tenRandomFiis()
        }
        collectionTopDY?.reloadData()
    }
    
    func showPublications(_ pub: [FiisNews]) {
        if !pub.isEmpty {
            HomeModel.listAllPublication = pub
            HomeModel.listPublication = pub.filterAccordingToUserDefinition()
            DispatchQueue.main.async {
                self.lbLoadingNews.text?.removeAll()
                self.pagePublication.numberOfPages = HomeModel.listPublication.count
                self.currentSlide = 0
                self.collectionPublication.reloadData()
                self.timer?.invalidate()
                if true.description.elementsEqual(UserDefaults.standard.string(forKey: UserDefaultKeys.changeNews.rawValue) ?? true.description) {
                    self.timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.nextNews), userInfo: nil, repeats: true)
                }
                
            }
        }
    }
    
    //    func showTallAndShort(_ list: [[(String,String)]]) {
    func showTallAndShort() {
        //        if !list[0].isEmpty {
        //            var temp = list
        //            DispatchQueue.main.async {
        //                for i in 0...1 {
        //                    let fii = ListFii.listFiis.first(where: {$0.code == temp[i].first?.0})
        //                    self.collectionImageStatic[i].image = UIImage(named: fii?.segment?.lowercased() ?? "outros") ?? UIImage(named: "outros")
        //                    self.collectionLabelSubTitle[i].text = fii?.socialReason
        //                    self.collectionButton[i].setTitle(fii?.code, for: .normal)
        //                    !temp[i].isEmpty ? temp[i].removeFirst() : nil
        //                }
        //            }
        //        }
        DispatchQueue.main.async {
            for i in 0...1 {
                if !HomeModel.listHighLow.isEmpty {
                    if i < HomeModel.listHighLow.count {
                        self.collectionImageStatic[i].image = UIImage(named: HomeModel.listHighLow[i].segment?.lowercased() ?? "outros") ?? UIImage(named: "outros")
                        self.collectionLabelSubTitle[i].text = HomeModel.listHighLow[i].socialReason
                        self.collectionButton[i].setTitle(HomeModel.listHighLow[i].code, for: .normal)
                    }
                }
            }
        }
    }
    
    func showPhrase() {
        collectionLabelSubTitle[2].text = HomeModel.phrase.phrase
        collectionLabelSubTitle[3].text = HomeModel.phrase.author
    }
    
    @IBAction func didTapButton(_ sender: UIButton) {
        sender.pulseEffectInClick()
        switch sender {
        case btnConfigureNews:
            let vc = storyboard?.instantiateViewController(withIdentifier: "configureNews") as! ConfigureNewsViewController
            present(vc, animated: true, completion: nil)
            
        case collectionButton[0]:
            ListFii.listFiis.forEach({
                if $0.code == collectionButton[0].title(for: .normal) {
                    setFii($0)
                }
            })
            
        case collectionButton[1]:
            ListFii.listFiis.forEach({
                if $0.code == collectionButton[1].title(for: .normal) {
                    setFii($0)
                }
            })
         
        case btnSeeNewMessage:
            segueTo(destination: storyboard?.instantiateViewController(withIdentifier: "inbox") as! UserInboxViewController)
            
        default:
            break
        }
        
    }
    
    @IBAction func didTapFilter(_ sender: UIButton) {
        sender.pulseEffectInClick()
        if viewFilter.isHidden {
            viewFilter = self.showFilter(sender)
        } else {
            viewFilter.isHidden = true
        }
    }
    
}


extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case collectionPublication:
            return HomeModel.listPublication.count //> 10 ? 10 : listPublication.count
            
        case collectionTopic:
            return arrayTemp.count
            
        default:
            return HomeModel.tenRandomFiis?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case collectionPublication:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellPublication", for: indexPath) as! PublicationCollectionViewCell
            cell.setPublication(pub: HomeModel.listPublication[indexPath.row])
            return cell
            
        case collectionTopic:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellTopic", for: indexPath) as! TopicCollectionViewCell
            cell.setData(from: (arrayTemp as! [(String, String)])[indexPath.row])
            let show = (InitializationModel.arrayFlagNewOrUpdatedItem.first(where: {$0.0.description().elementsEqual((arrayTemp as! [(String, String)])[indexPath.row].1)}) != nil) ? true : false
            cell.setItemFlagNew(!show)
            return cell
            
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TopDYCollectionViewCell
            cell.setFii(HomeModel.tenRandomFiis![indexPath.row])
            return cell
        }
    }
    
}


extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView {
        case collectionPublication:
            return 0
        case collectionTopic:
            return 20
        default:
            return 16
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case collectionPublication:
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
            
        case collectionTopic:
            return CGSize(width: 250 / 2, height: 250 / 4)
            
        case collectionTopDY:
            return CGSize(width: 150, height: 200)
            
        default:
            return CGSize()
        }
    }
}



extension HomeViewController: UICollectionViewDelegate {
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
        switch collectionView {
        case collectionTopDY:
            let cell = collectionView.cellForItem(at: indexPath) as? TopDYCollectionViewCell
            setFii(FIIModel.Fetch.FII.init(socialReason: "", name: cell?.collectionLabel[1].text, code: cell?.collectionLabel[0].text, segment: nil, price: cell?.collectionLabel[2].text, earnings: nil))
            
        case collectionTopic:
            let cell = collectionView.cellForItem(at: indexPath) as? TopicCollectionViewCell
            interactor?.setItemLibrary(cell?.labelTitle.text ?? "")
            router?.routeTosegueDetailWithSegue(segue: nil)
            
        default:
            let cell = collectionView.cellForItem(at: indexPath) as! PublicationCollectionViewCell
            newsUrl = cell.urlSite
            if UserDefaults.standard.bool(forKey: UserDefaultKeys.hideNewsAlert.rawValue) {
                newsUrl?.openUrl()
            } else {
                showAlert(.info, NSLocalizedString("da_news", comment: ""))
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        //        let cell = collectionView.cellForItem(at: indexPath) as? MyVideosCollectionViewCell
        //        cell?.playPressed()
    }
}


extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pagePublication.currentPage = Int(pageIndex)
        currentSlide = pagePublication.currentPage
    }
    
}

extension HomeViewController: NavigationBarFooterDelegate {
    func didTapButtonNavigation(_ sender: UIButton) {
        var vc: UIViewController!
        switch sender.tag {
        case 1:
            vc = storyboard?.instantiateViewController(withIdentifier: "wallet") as! WalletViewController
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


extension HomeViewController: ActionButtonAlertDelegate {
    func close() {
        dismiss(animated: true) {
            Util.hideAlertMessage()
            self.newsUrl?.openUrl()
        }
        
    }
}


extension HomeViewController {
    func showFilter(_ button: UIButton) -> UIView {
        var listButtons = [UIButton]()
        let filter = UIView(frame: CGRect(x: button.frame.width * 0.5, y: button.frame.height * 0.5, width: 0, height: 0))
        filter.backgroundColor = .white
        filter.layer.borderWidth = 2
        filter.layer.borderColor = UIColor(named: "Font")?.cgColor
        filter.layer.cornerRadius = 16
        filter.isHidden = true
        filter.alpha = 0
        filter.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(filter)
        
        listButtons.append(UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 30)))
        listButtons[0].setTitle("Maiores Preços", for: .normal)
        filter.addSubview(listButtons[0])
        
        NSLayoutConstraint.activate([
            listButtons[0].heightAnchor.constraint(equalToConstant: 25),
            listButtons[0].topAnchor.constraint(equalTo: filter.topAnchor, constant: 16),
            listButtons[0].trailingAnchor.constraint(equalTo: filter.trailingAnchor, constant: -8),
            listButtons[0].leadingAnchor.constraint(equalTo: filter.leadingAnchor, constant: 8)
        ])
        
        listButtons.append(UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 30)))
        listButtons[1].setTitle("Menores Preços", for: .normal)
        filter.addSubview(listButtons[1])
        
        NSLayoutConstraint.activate([
            listButtons[1].heightAnchor.constraint(equalToConstant: 25),
            listButtons[1].topAnchor.constraint(equalTo: listButtons[0].bottomAnchor, constant: 16),
            listButtons[1].trailingAnchor.constraint(equalTo: listButtons[0].trailingAnchor, constant: 0),
            listButtons[1].leadingAnchor.constraint(equalTo: listButtons[0].leadingAnchor, constant: 0)
        ])
        
        listButtons.append(UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 30)))
        listButtons[2].setTitle("Maiores DY", for: .normal)
        filter.addSubview(listButtons[2])
        
        
        NSLayoutConstraint.activate([
            listButtons[2].heightAnchor.constraint(equalToConstant: 25),
            listButtons[2].topAnchor.constraint(equalTo: listButtons[1].bottomAnchor, constant: 16),
            listButtons[2].trailingAnchor.constraint(equalTo: listButtons[1].trailingAnchor, constant: 0),
            listButtons[2].leadingAnchor.constraint(equalTo: listButtons[1].leadingAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            filter.widthAnchor.constraint(equalToConstant: 200),
            filter.heightAnchor.constraint(equalToConstant: 140),
            filter.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -14),
            filter.topAnchor.constraint(equalTo: button.bottomAnchor, constant: -10)
        ])
        UIView.animate(withDuration: 0.5) {
            filter.isHidden = false
            filter.alpha = 1
        }
        
        for i in 0..<listButtons.count {
            listButtons[i].translatesAutoresizingMaskIntoConstraints = false
            listButtons[i].tag = i
            listButtons[i].layer.borderColor = UIColor(named: "Border")?.cgColor
            listButtons[i].layer.borderWidth = 2
            listButtons[i].layer.cornerRadius = 12
            listButtons[i].backgroundColor = .white
            listButtons[i].setTitleColor(UIColor(named: "Font"), for: .normal)
            listButtons[i].addTarget(self, action: #selector(closeViewFilter), for: .touchUpInside)
        }
        
        return filter
    }
}

