//
//  SceneDelegate.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 1/13/22.
//

import UIKit
import GoogleMobileAds
import FBSDKCoreKit
import GoogleSignIn

class SceneDelegate: UIResponder, UIWindowSceneDelegate, GADFullScreenContentDelegate {

    var window: UIWindow?
    var appOpenAd: GADAppOpenAd?
    var loadTime = Date()
    var isAdOnScreen = false
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
            return
        }

        ApplicationDelegate.shared.application(
            UIApplication.shared,
            open: url,
            sourceApplication: nil,
            annotation: [UIApplication.OpenURLOptionsKey.annotation]
        )
    }


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let scene = (scene as? UIWindowScene) else { return }
        Settings.shared.isAdvertiserTrackingEnabled = true
        configureRootVC(with: scene)
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        
        self.tryToPresentAd()
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    private func configureRootVC(with scene: UIWindowScene) {
        window = UIWindow(windowScene: scene)
        
        // MARK: new revamped version
        
        let vc = MenuVC()
        MenuModels.shared.initialize()
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
    }
    
    func requestAppOpenAd(completion: (() -> Void)?) {
        let request = GADRequest()
        // this is test ad unit
        if !isAdOnScreen {
            print("load ad")
            let testUnit = "ca-app-pub-3940256099942544/3419835294"
            let paidUnut = "ca-app-pub-4520908978346246/8487103681"
            GADAppOpenAd.load(withAdUnitID: testUnit,
                              request: request,
                              orientation: UIInterfaceOrientation.portrait,
                              completionHandler: { [weak self] (appOpenAdIn, _) in
                guard let self = self else { return }
                self.appOpenAd = appOpenAdIn
                self.appOpenAd?.fullScreenContentDelegate = self
                //self.tryToPresentAd()
                //print("Ad is ready")
                if let completion = completion {
                    self.isAdOnScreen = true
                    completion()
                }
                
            })
        }
    }
    func tryToPresentAd() {
        if let gOpenAd = self.appOpenAd, let rwc = window!.rootViewController {
            gOpenAd.present(fromRootViewController: rwc)
        }
        else {
            self.requestAppOpenAd() { [weak self] in
                guard let self = self else { return }
                self.appOpenAd?.present(fromRootViewController: self.window!.rootViewController!)
            }
            
        }
    }
    
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("error is \(error.localizedDescription)")
        //requestAppOpenAd(completion: nil)
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("dismiss")
        
        //requestAppOpenAd(completion: nil)
    }
    
    func adWillDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("will dismiss")
        self.isAdOnScreen = false
        self.appOpenAd = nil
    }
    
//    func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
//        print("Ad did present")
//
//    }
    
}
