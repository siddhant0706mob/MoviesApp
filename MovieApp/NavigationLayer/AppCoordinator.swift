//
//  Untitled.swift
//  MovieApp
//
//  Created by Siddhant Ranjan on 12/07/25.
//

import UIKit

protocol AppCoordinatorDelegate: AnyObject {
    func openMovieDetails(for movieId: Int)
    func openSavedMoviesPage()
}

class AppCoordinator: NSObject, AppCoordinatorDelegate, UITabBarControllerDelegate {
    private let window: UIWindow
    private let configApiService: APIServiceProtocol
    private var rootNavigationController: UINavigationController?
    private var splashVC: SplashViewController?
    private var tabController = UITabBarController()
    
    init(window: UIWindow) {
        self.window = window
        self.configApiService = APIServiceFactory.getApiService(for: .configuration)
    }
    
    func start() {
        showSplash()
        //Adding delay since configuration api is too fast and splash is not visible
        //        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
        fetchConfiguration()
        //        }
    }
    
    private func showSplash() {
        splashVC = SplashViewController()
        if let splashVC {
            rootNavigationController = UINavigationController(rootViewController: splashVC)
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
        homeViewController.coordinatorDelegate = self
        homeViewController.tabBarItem = UITabBarItem(title: "Home",
                                                     image: UIImage(systemName: "house"),
                                                     selectedImage: UIImage(systemName: "house.fill"))
        let viewModel = SavedMoviesViewModel()
        let savedMoviesController = SavedMoviesController(viewModel)
        savedMoviesController.coordinatorDelegate = self
        savedMoviesController.tabBarItem = UITabBarItem(title: "Saved",
                                                        image: UIImage(systemName: "bookmark"),
                                                        selectedImage: UIImage(systemName: "bookmark.fill"))
        
        let iconInset: CGFloat = 5.0
        
        let homeTabBarItem = UITabBarItem(title: "Home",
                                          image: UIImage(systemName: "house"),
                                          selectedImage: UIImage(systemName: "house.fill"))
        homeTabBarItem.imageInsets = UIEdgeInsets(top: iconInset, left: 0, bottom: -iconInset, right: 0)
        homeViewController.tabBarItem = homeTabBarItem
        
        let savedTabBarItem = UITabBarItem(title: "Saved",
                                           image: UIImage(systemName: "bookmark"),
                                           selectedImage: UIImage(systemName: "bookmark.fill"))
        savedTabBarItem.imageInsets = UIEdgeInsets(top: iconInset, left: 0, bottom: -iconInset, right: 0)
        savedMoviesController.tabBarItem = savedTabBarItem
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        
        appearance.stackedLayoutAppearance.normal.iconColor = .gray
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.gray]
        appearance.stackedLayoutAppearance.selected.iconColor = .black
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.black]
        
        tabController.tabBar.standardAppearance = appearance
        tabController.tabBar.scrollEdgeAppearance = appearance
        tabController.delegate = self
        
        splashVC?.dismissSplash { [weak self] in
            guard let self else { return }
            self.rootNavigationController?.popViewController(animated: false)
            tabController.viewControllers = [homeViewController, savedMoviesController]
            tabController.navigationItem.hidesBackButton = true
            self.rootNavigationController?.pushViewController(tabController, animated: true)
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController is SavedMoviesController {
            tabController.navigationItem.hidesBackButton = true
            tabController.navigationItem.title = "Saved Movies"
        }
    }
    
    func openMovieDetails(for movieId: Int) {
        let vc = MovieDetailsViewController(movieId: movieId)
        rootNavigationController?.pushViewController(vc, animated: true)
    }
    
    func openSavedMoviesPage() {
        
    }
}
