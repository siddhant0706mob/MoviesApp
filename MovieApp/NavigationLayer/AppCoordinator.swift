//
//  Untitled.swift
//  MovieApp
//
//  Created by Siddhant Ranjan on 12/07/25.
//

import UIKit

protocol AppCoordinatorDelegate: AnyObject {
    func openMovieDetails(for movieId: Int)
}

class AppCoordinator: NSObject, AppCoordinatorDelegate, UITabBarControllerDelegate {
    private let window: UIWindow
    private let configApiService: APIServiceProtocol
    private var rootNavigationController: UINavigationController?
    private var splashVC: SplashViewController?
    private var tabController = UITabBarController()
    private var homeViewController: HomeViewController?
    private var savedMoviesController: SavedMoviesController?
    private var searchViewController: SearchViewController?
    
    init(window: UIWindow) {
        self.window = window
        self.configApiService = APIServiceFactory.getApiService(for: .configuration)
    }
    
    func start() {
        setupControllers()
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
    
    private func setupTabBarController(_ homeViewController: UIViewController?,_ savedMoviesController: UIViewController?) {
        let iconInset: CGFloat = 5.0
        let homeTabBarItem = UITabBarItem(title: "Home",
                                          image: UIImage(systemName: "house"),
                                          selectedImage: UIImage(systemName: "house.fill"))
        homeTabBarItem.imageInsets = UIEdgeInsets(top: iconInset, left: 0, bottom: -iconInset, right: 0)
        homeViewController?.tabBarItem = homeTabBarItem
        
        let savedTabBarItem = UITabBarItem(title: "Saved",
                                           image: UIImage(systemName: "bookmark"),
                                           selectedImage: UIImage(systemName: "bookmark.fill"))
        savedTabBarItem.imageInsets = UIEdgeInsets(top: iconInset, left: 0, bottom: -iconInset, right: 0)
        savedMoviesController?.tabBarItem = savedTabBarItem
        
        let searchTabBarItem = UITabBarItem(title: "Search",
                                            image: UIImage(systemName: "magnifyingglass"),
                                            selectedImage: UIImage(systemName: "magnifyingglass.fill"))
        searchTabBarItem.imageInsets = UIEdgeInsets(top: iconInset, left: 0, bottom: -iconInset, right: 0)
        searchViewController?.tabBarItem = searchTabBarItem
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        
        appearance.stackedLayoutAppearance.normal.iconColor = .gray
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.gray]
        appearance.stackedLayoutAppearance.selected.iconColor = .black
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.black]
        
        tabController.tabBar.standardAppearance = appearance
        tabController.tabBar.scrollEdgeAppearance = appearance
        tabController.delegate = self
    }
    
    private func setupControllers() {
        let homeViewModel = HomeViewModel()
        homeViewController = HomeViewController(homeViewModel)
        homeViewController?.coordinatorDelegate = self
        
        let viewModel = SavedMoviesViewModel()
        savedMoviesController = SavedMoviesController(viewModel)
        savedMoviesController?.coordinatorDelegate = self
        
        let searchViewModel = SearchViewModel()
        searchViewController = SearchViewController(searchViewModel)
        
        setupTabBarController(homeViewController, savedMoviesController)
    }
    
    private func startHomeFeedFlow() {
        splashVC?.dismissSplash { [weak self] in
            guard let self,
                  let homeViewController,
                  let savedMoviesController,
                  let searchViewController else { return }
            let homeNav = UINavigationController(rootViewController: homeViewController)
            let savedNav = UINavigationController(rootViewController: savedMoviesController)
            let searchNav = UINavigationController(rootViewController: searchViewController)
            tabController.viewControllers = [homeNav, savedNav, searchNav]
            self.window.rootViewController = tabController
            self.window.makeKeyAndVisible()
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if tabBarController.selectedIndex == 1 {
            tabController.navigationItem.hidesBackButton = true
            tabController.navigationItem.title = "Saved Movies"
        } else {
            tabController.navigationItem.title  = ""
        }
    }
    
    func openMovieDetails(for movieId: Int) {
        let vc = MovieDetailsViewController(movieId: movieId)
        if let selectedNavController = tabController.selectedViewController as? UINavigationController {
            selectedNavController.pushViewController(vc, animated: true)
            vc.hidesBottomBarWhenPushed = true
        } else {
            let navController = UINavigationController(rootViewController: vc)
            window.rootViewController?.present(navController, animated: true)
        }
    }
}
