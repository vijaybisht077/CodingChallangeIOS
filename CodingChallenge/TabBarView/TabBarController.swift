//
//  TabBarController.swift
//  CodingChallenge
//
//  Created by vijaybisht on 23/05/24.
//

import Foundation
import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let postsViewModel = PostsViewModel()
        let postsViewController = PostsViewController(viewModel: postsViewModel)
        postsViewController.title = "Posts"
        let postsNavigationController = UINavigationController(rootViewController: postsViewController)
        postsNavigationController.tabBarItem = UITabBarItem(title: "Posts",
                                                            image: UIImage(systemName: "list.bullet"),
                                                            tag: 0)

        let favoritesViewController = FavoritesViewController(viewModel: postsViewModel)
        favoritesViewController.title = "Favorites"
        let favoritesNavigationController = UINavigationController(rootViewController: favoritesViewController)
        favoritesNavigationController.tabBarItem = UITabBarItem(title: "Favorites",
                                                                image: UIImage(systemName: "star.fill"),
                                                                tag: 1)
        viewControllers = [postsNavigationController, favoritesNavigationController]
    }
}
