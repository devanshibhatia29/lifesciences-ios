//
//  MainTabBarController.swift
//  NetflixClone
//
//  Created by Developer on 2024/01/01.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setupViewControllers()
    }
    
    private func setupTabBar() {
        tabBar.tintColor = .white
        tabBar.barTintColor = .black
        tabBar.backgroundColor = .black
        tabBar.isTranslucent = false
    }
    
    private func setupViewControllers() {
        let homeVC = HomeViewController()
        let searchVC = SearchViewController()
        let comingSoonVC = ComingSoonViewController()
        let downloadsVC = DownloadsViewController()
        
        let homeNav = UINavigationController(rootViewController: homeVC)
        let searchNav = UINavigationController(rootViewController: searchVC)
        let comingSoonNav = UINavigationController(rootViewController: comingSoonVC)
        let downloadsNav = UINavigationController(rootViewController: downloadsVC)
        
        // Configure navigation bar appearance
        configureNavigationBar(homeNav)
        configureNavigationBar(searchNav)
        configureNavigationBar(comingSoonNav)
        configureNavigationBar(downloadsNav)
        
        // Set tab bar items with correct spelling
        homeNav.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        
        searchNav.tabBarItem = UITabBarItem(
            title: "Search",
            image: UIImage(systemName: "magnifyingglass"),
            selectedImage: UIImage(systemName: "magnifyingglass")
        )
        
        comingSoonNav.tabBarItem = UITabBarItem(
            title: "Coming Soon",
            image: UIImage(systemName: "play.circle"),
            selectedImage: UIImage(systemName: "play.circle.fill")
        )
        
        downloadsNav.tabBarItem = UITabBarItem(
            title: "Downloads",
            image: UIImage(systemName: "arrow.down.to.line"),
            selectedImage: UIImage(systemName: "arrow.down.to.line.compact")
        )
        
        viewControllers = [homeNav, searchNav, comingSoonNav, downloadsNav]
    }
    
    private func configureNavigationBar(_ navigationController: UINavigationController) {
        navigationController.navigationBar.tintColor = .white
        navigationController.navigationBar.barTintColor = .black
        navigationController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController.navigationBar.isTranslucent = false
    }
}