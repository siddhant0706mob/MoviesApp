//
//  SceneDelegate.swift
//  MovieApp
//
//  Created by Siddhant Ranjan on 07/07/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate, SplashPresentationDelegate {
    var window: UIWindow?

    private let splashController = SplashViewController()
    private lazy var navViewController: UINavigationController = {
        return UINavigationController(rootViewController: splashController)
    }()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        splashController.delegate = self
        window?.windowScene = windowScene
        window?.makeKeyAndVisible()
        window?.rootViewController = navViewController
        DispatchQueue.main.asyncAfter(deadline: .now() + 6.25, execute: {
            self.splashController.dismissSplash()
        })
    }

    func splashDidFinishLaunching() {
        transformNewController()
    }
    
    private func transformNewController() {
        let transition = CATransition()
        let homeVC = HomeViewController()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromTop
        navViewController.view.layer.add(transition, forKey: kCATransition)
        navViewController.pushViewController(homeVC, animated: true)
    }

    func sceneDidDisconnect(_ scene: UIScene) { }

    func sceneDidBecomeActive(_ scene: UIScene) { }

    func sceneWillResignActive(_ scene: UIScene) { }

    func sceneWillEnterForeground(_ scene: UIScene) { }

    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}

