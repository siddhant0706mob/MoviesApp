//
//  Untitled.swift
//  MovieApp
//
//  Created by Siddhant Ranjan on 12/07/25.
//

import UIKit

class AppCoordinator {
    private let window: UIWindow
    private let configApiService: APIServiceProtocol
    private var rootNavigationController: UINavigationController?
    private var splashVC: SplashViewController?
    
    init(window: UIWindow) {
        self.window = window
        self.configApiService = APIServiceFactory.getApiService(for: .configuration)
    }
    
    func start() {
        showSplash()
        //Adding delay since configuration api is too fast and splash is not visible
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.fetchConfiguration()
        }
    }
    
    private func showSplash() {
        splashVC = SplashViewController()
        if let splashVC {
            rootNavigationController = UINavigationController(rootViewController: splashVC)
            rootNavigationController?.isNavigationBarHidden = true
            window.rootViewController = rootNavigationController
        }
    }
    
    private func fetchConfiguration() {
        if let configService = configApiService as? ConfigApiServiceProtocol {
            configService.fetchAndStoreConfig({ [weak self] result in
                if case .success = result {
                    DispatchQueue.main.async {
                        self?.startHomeFeedFlow()
                    }
                } else { }
            })
        }
    }
    
    private func startHomeFeedFlow() {
        let homeViewModel = HomeViewModel()
        let homeViewController = HomeViewController(homeViewModel)
        splashVC?.dismissSplash { [weak self] in
            guard let self else { return }
            self.rootNavigationController?.popViewController(animated: false)
            self.rootNavigationController?.pushViewController(homeViewController, animated: true)
        }
    }
}
