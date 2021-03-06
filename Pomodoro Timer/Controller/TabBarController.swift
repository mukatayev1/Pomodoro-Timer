//
//  TabBarController.swift
//  Pomodoro Focus Timer
//
//  Created by AZM on 2020/10/03.
//

import UIKit

class TabBarController: UITabBarController {
    
    let timerImage = UIImage(systemName: "timer", withConfiguration: UIImage.SymbolConfiguration(weight: .light))
    
    let gearImage = UIImage(systemName: "gear", withConfiguration: UIImage.SymbolConfiguration(weight: .light))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.tintColor = #colorLiteral(red: 0.4156862745, green: 0.09803921569, blue: 0.4901960784, alpha: 1)
        let nav1 = generateNavController(vc: TimerViewController(), title: "Timer", image: timerImage!, showTitle: false)
        let nav2 = generateNavController(vc: SettingsViewController(), title: "Settings", image: gearImage!, showTitle: true)
        viewControllers = [nav1, nav2]
        
    }
    
    fileprivate func generateNavController(vc: UIViewController, title: String, image: UIImage, showTitle: Bool) -> UINavigationController {
        if showTitle == true {
            vc.navigationItem.title = title
        } else {
        }
        
        
        let navController = UINavigationController(rootViewController: vc)
        navController.tabBarItem.image = image
        navController.tabBarItem.title = title
  
        return navController
    }
}

class CustomTabBar: UITabBar {
 
    override func sizeThatFits(_ size: CGSize) -> CGSize {
          var size = super.sizeThatFits(size)
          size.height = 70
          return size
     }
}

