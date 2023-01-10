//
//  MoreOptionsWalletViewController.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 30/05/22.
//

import UIKit
import GoogleMobileAds

class MoreOptionsWalletViewController: UIViewController {
    
    @IBOutlet weak var viewHeader: NavigationBarHeaderView!
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var collectionOptions: UICollectionView!
    @IBOutlet weak var btnViewQuotes: UIButton!
    
    var listOptions = [String]()
    
    enum MoreOptionsWallet: String, CaseIterable {
        case line_chart
        case time
        case quotes
        case pie_chart
        case report
        case wallet
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewHeader.setTitleHeader(name: NSLocalizedString("details", comment: ""))
        viewHeader.delegate = self
        
        //        viewBackground.backgroundColor = UIColor(named: "Border")
        viewBackground.layer.cornerRadius = 40
        
        collectionOptions.delegate = self
        collectionOptions.dataSource = self
        collectionOptions.backgroundColor = .clear
        
        MoreOptionsWallet.allCases.forEach({ listOptions.append($0.rawValue) })
        listOptions.sort(by: {$0 < $1})
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        btnViewQuotes.setTitle(NSLocalizedString("see_quotes", comment: ""), for: .normal)
        btnViewQuotes.isHidden = true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        btnViewQuotes.isHidden = Ad.rewardedAd == nil ? true : false
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
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
    
    @IBAction func showReward(_ sender: Any) {
        Ad.showRewarded(self) { response in
            Ad.rewardedAd?.fullScreenContentDelegate = self
        }
    }
}


extension MoreOptionsWalletViewController: NavigationBarHeaderDelegate {
    func didTapButtonBack(_ sender: UIButton) {
        dismissWith()
    }
    
}


extension MoreOptionsWalletViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listOptions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MoreOptionsWalletCollectionViewCell
        cell.setData(from: listOptions[indexPath.row])
        if UserDefaultKeys.vip.getValue() as! Bool == false, !listOptions[indexPath.row].elementsEqual(MoreOptionsWallet.time.rawValue), !listOptions[indexPath.row].elementsEqual(MoreOptionsWallet.wallet.rawValue) {
            cell.isUserInteractionEnabled = false
            cell.img.alpha = 0.5
            cell.pro.isHidden = cell.isUserInteractionEnabled
        }
        
        return cell
    }
    
    
}


extension MoreOptionsWalletViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! MoreOptionsWalletCollectionViewCell
        switch cell.title.text! {
        case NSLocalizedString(MoreOptionsWallet.time.rawValue, comment: ""):
            segueTo(destination: storyboard?.instantiateViewController(withIdentifier: "historic") as! WalletHistoricViewController)
            
        case NSLocalizedString(MoreOptionsWallet.line_chart.rawValue, comment: ""):
            segueTo(destination: storyboard?.instantiateViewController(withIdentifier: "lineChart") as! ChartViewController)
            
        case NSLocalizedString(MoreOptionsWallet.quotes.rawValue, comment: ""):
            segueTo(destination: storyboard?.instantiateViewController(withIdentifier: "quotes") as! WalletQuotesViewController)
            
        case NSLocalizedString(MoreOptionsWallet.pie_chart.rawValue, comment: ""):
            segueTo(destination: storyboard?.instantiateViewController(withIdentifier: "pieChart") as! ProportionViewController)
            
        case NSLocalizedString(MoreOptionsWallet.report.rawValue, comment: ""):
            segueTo(destination: storyboard?.instantiateViewController(withIdentifier: "report") as! ReportViewController)
            
        case NSLocalizedString(MoreOptionsWallet.wallet.rawValue, comment: ""):
            segueTo(destination: storyboard?.instantiateViewController(withIdentifier: "about_wallet") as! AboutViewController)
            
        default:
            break
        }
    }
}


extension MoreOptionsWalletViewController: GADFullScreenContentDelegate {
    /// Tells the delegate that the ad failed to present full screen content.
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad did fail to present full screen content.")
    }
    
    /// Tells the delegate that the ad will present full screen content.
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad will present full screen content.")
    }
    
    /// Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        Ad.rewardedAd = nil
        segueTo(destination: storyboard?.instantiateViewController(withIdentifier: "quotes") as! WalletQuotesViewController)
    }
}
