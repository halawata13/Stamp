//
//  BaseTabBarController.swift
//

import UIKit

final class BaseTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.barTintColor = UIColor(red: 0 / 255, green: 171 / 255, blue: 141 / 255, alpha: 1)
        UITabBar.appearance().tintColor = UIColor.white
        UITabBar.appearance().unselectedItemTintColor = UIColor(red: 222 / 255, green: 222 / 255, blue: 222 / 255, alpha: 1)
    }
}
