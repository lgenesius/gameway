//
//  TabBarViewController.swift
//  Gameway
//
//  Created by Luis Genesius on 06/01/22.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.tintColor = .vividYellow
        
        let homeVC = HomeViewControllerFactory().createViewController()
        let giveawayVC = GiveawayViewController()
        let statusVC = StatusViewController()
        
        homeVC.title = "Home"
        giveawayVC.title = "Giveaway"
        statusVC.title = "Status"
        
        homeVC.navigationItem.largeTitleDisplayMode = .always
        giveawayVC.navigationItem.largeTitleDisplayMode = .always
        statusVC.navigationItem.largeTitleDisplayMode = .always

        let homeNC = UINavigationController(rootViewController: homeVC)
        let giveawayNC = UINavigationController(rootViewController: giveawayVC)
        let statusNC = UINavigationController(rootViewController: statusVC)
        
        homeNC.navigationBar.tintColor = .label
        giveawayNC.navigationBar.tintColor = .label
        statusNC.navigationBar.tintColor = .label
        
        homeNC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 1)
        giveawayNC.tabBarItem = UITabBarItem(title: "Giveaway", image: UIImage(systemName: "gamecontroller"), tag: 2)
        statusNC.tabBarItem = UITabBarItem(title: "Status", image: UIImage(systemName: "note.text"), tag: 3)
        
        homeNC.navigationBar.prefersLargeTitles = true
        giveawayNC.navigationBar.prefersLargeTitles = true
        statusNC.navigationBar.prefersLargeTitles = true
        
        setViewControllers([homeNC, giveawayNC, statusNC], animated: false)
    }
}
