//
//  Ad.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 15/10/22.
//

import Foundation
import GoogleMobileAds

typealias responseReward = (_ response: NSDecimalNumber) ->()

class Ad {
    enum AdKeys: String {
        case banner
        case reward
        case open
        
        func getKey() -> String {
            let dictionary = Bundle.main.infoDictionary?["ListAdKeys"] as? Dictionary<String, String>
            return dictionary?.first(where: {$0.key.uppercased().elementsEqual(self.rawValue.uppercased())})?.value ?? ""
        }
    }
    
    static var rewardedAd: GADRewardedAd?
    
    static func showBanner(_ banner: GADBannerView, _ root: UIViewController) {
        banner.adUnitID = AdKeys.banner.getKey()
        banner.rootViewController = root
        UserDefaultKeys.vip.getValue() as! Bool ? nil : banner.load(GADRequest())
    }
    
    static func showRewarded(_ root: UIViewController, complete:@escaping(responseReward)) {
        if let ad = rewardedAd {
            ad.present(fromRootViewController: root) {
                let reward = ad.adReward
                print("Reward received with currency \(reward.amount), amount \(reward.amount.doubleValue)")
                // TODO: Reward the user.
                complete(reward.amount)
            }
        } else {
            complete(0.0)
        }
    }
    
    //    static func showRewarded_old(_ root: UIViewController, complete:@escaping(responseRewardedAd)) {
    //        let request = GADRequest()
    //        GADRewardedAd.load(withAdUnitID: AdKeys.reward.getKey(), request: request, completionHandler: { ad, error in
    //            if let error = error {
    //                print("Failed to load rewarded ad with error: \(error.localizedDescription)")
    //                let alert = UIAlertController(
    //                    title: "Deu ruim",
    //                    message: "The rewarded ad cannot be shown at this time",
    //                    preferredStyle: .alert)
    //                let alertAction = UIAlertAction(
    //                    title: "ruim",
    //                    style: .cancel,
    //                    handler: { action in
    //                        print()
    //                        complete(GADRewardedAd())
    //                    })
    //                alert.addAction(alertAction)
    //                root.present(alert, animated: true, completion: nil)
    //            } else {
    //                rewardedAd = ad
    //                if let ad = rewardedAd {
    //                    ad.present(fromRootViewController: root) {
    //                        let reward = ad.adReward
    //                        print("Reward received with currency \(reward.amount), amount \(reward.amount.doubleValue)")
    //                        // TODO: Reward the user.
    //                        complete(rewardedAd!)
    //                    }
    //                } else {
    //                    let alert = UIAlertController(
    //                        title: "Rewarded ad isn't available yet.",
    //                        message: "The rewarded ad cannot be shown at this time",
    //                        preferredStyle: .alert)
    //                    let alertAction = UIAlertAction(
    //                        title: "OK",
    //                        style: .cancel,
    //                        handler: { action in
    //                            print()
    //                            complete(GADRewardedAd())
    //                        })
    //                    alert.addAction(alertAction)
    //                    root.present(alert, animated: true, completion: nil)
    //                }
    //            }
    //        })
    //    }
    
    
    static func checkSponsor() {
        if UserDefaultKeys.vip.getValue() as! Bool == false {
            let request = GADRequest()
            GADRewardedAd.load(withAdUnitID: AdKeys.reward.getKey(), request: request, completionHandler: { ad, error in
                if let error = error {
                    print("Failed to load rewarded ad with error: \(error.localizedDescription)")
                    //                let alert = UIAlertController(
                    //                    title: "Deu ruim",
                    //                    message: "The rewarded ad cannot be shown at this time",
                    //                    preferredStyle: .alert)
                    //                let alertAction = UIAlertAction(
                    //                    title: "ruim",
                    //                    style: .cancel,
                    //                    handler: { action in
                    //                        print()
                    //                    })
                    //                alert.addAction(alertAction)
                    //                root.present(alert, animated: true, completion: nil)
                } else {
                    Ad.rewardedAd = ad
                    if let _ = Ad.rewardedAd {
                        return
                        //                    ad.present(fromRootViewController: root) {
                        //                        let reward = ad.adReward
                        //                        print("Reward received with currency \(reward.amount), amount \(reward.amount.doubleValue)")
                        //                        // TODO: Reward the user.
                        //                    }
                    } else {
                        //                    let alert = UIAlertController(
                        //                        title: "Rewarded ad isn't available yet.",
                        //                        message: "The rewarded ad cannot be shown at this time",
                        //                        preferredStyle: .alert)
                        //                    let alertAction = UIAlertAction(
                        //                        title: "OK",
                        //                        style: .cancel,
                        //                        handler: { action in
                        //                            print()
                        //                        })
                        //                    alert.addAction(alertAction)
                        //                    root.present(alert, animated: true, completion: nil)
                    }
                }
            })
        }
    }
}
