//
//  BaseTabBarController.swift
//

import UIKit

final class BaseTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.barTintColor = UIColor(red: 0 / 255, green: 171 / 255, blue: 141 / 255, alpha: 1)
        UITabBar.appearance().tintColor = UIColor(red: 212 / 255, green: 253 / 255, blue: 246 / 255, alpha: 1)
        UITabBar.appearance().unselectedItemTintColor = UIColor(red: 150 / 255, green: 227 / 255, blue: 214 / 255, alpha: 1)
    }
}
