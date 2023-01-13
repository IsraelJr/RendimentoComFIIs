//
//  AppDelegate.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 16/05/22.
//

import UIKit
import FirebaseCore
import GoogleSignIn
import AuthenticationServices
import GoogleMobileAds
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate, GADFullScreenContentDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        AppOpenAdManager.shared.loadAd()
        UNUserNotificationCenter.current().delegate = self
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        appleIDProvider.getCredentialState(forUserID: "currentUserIdentifier") { (credentialState, error) in
            switch credentialState {
            case .authorized:
                break // The Apple ID credential is valid.
            case .revoked, .notFound:
                // The Apple ID credential is either revoked or was not found, so show the sign-in UI.
                //                    DispatchQueue.main.async {
                //                        self.window?.rootViewController?.showLoginViewController()
                //                    }
                print()
            default:
                break
            }
        }
        
        registerForPushNotifications()
        
        // Check if launched from notification
        let notificationOption = launchOptions?[.remoteNotification]
        // 1
        if let notification = notificationOption as? [String: AnyObject], let aps = notification["aps"] as? [String: AnyObject] {
            // 2
            //          NewsItem.makeNewsItem(aps)
            
            // 3
            (window?.rootViewController as? UITabBarController)?.selectedIndex = 1
        }
        
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    var orientationLock = UIInterfaceOrientationMask.portrait
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.orientationLock
    }
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
        let x = GIDSignIn.sharedInstance.handle(url)
        return x
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        let rootViewController = application.windows.first(where: { $0.isKeyWindow })?.rootViewController
        if let rootViewController = rootViewController {
            // Do not show app open ad if the current view controller is SplashViewController.
            if rootViewController is SplashViewController {
                return
            }
            AppOpenAdManager.shared.showAdIfAvailable(viewController: rootViewController)
        }
    }
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current()
            .requestAuthorization(
                options: [.alert, .sound, .badge]) { [weak self] granted, _ in
                    print("Permission granted: \(granted)")
                    guard granted else { return }
                    
                    // 1
                    let viewAction = UNNotificationAction(
                        identifier: "Acao",
                        title: "View",
                        options: [.foreground])
                    
                    // 2
                    let newsCategory = UNNotificationCategory(
                        identifier: "NovaCategoria",
                        actions: [viewAction],
                        intentIdentifiers: [],
                        options: [])
                    
                    // 3
                    UNUserNotificationCenter.current().setNotificationCategories([newsCategory])
                    
                    
                    self?.getNotificationSettings()
                }
        
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
            
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler:@escaping (UIBackgroundFetchResult) -> Void) {
        guard let aps = userInfo["aps"] as? [String: AnyObject] else {
            completionHandler(.failed)
            return
        }
        // 1 igual a silencioso
        if aps["content-available"] as? Int == 1 {
            //          let podcastStore = PodcastStore.sharedStore
            //          // 2
            //          podcastStore.refreshItems { didLoadNewItems in
            //            // 3
            //            completionHandler(didLoadNewItems ? .newData : .noData)
            //          }
            print()
        } else {
            // 4
            //          NewsItem.makeNewsItem(aps)
            completionHandler(.newData)
        }
        
        print(aps.values)
    }
}


// MARK: - UNUserNotificationCenterDelegate

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        switch response.actionIdentifier {
            case "Acao":
                print()
            default:
                break
            }
        
        // 1
        let userInfo = response.notification.request.content.userInfo
        
        // 2
        if
            let aps = userInfo["aps"] as? [String: AnyObject]//,
        //      let newsItem = NewsItem.makeNewsItem(aps)
        {
            (window?.rootViewController as? UITabBarController)?.selectedIndex = 1
            
            // 3
            if response.actionIdentifier == "Acao" {
                let vc = WalletViewController()
                window?.rootViewController?
                    .present(vc, animated: true, completion: nil)
            }
        }
        
        // 4
        completionHandler()
    }
}
