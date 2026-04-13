//
//  TabBarController.swift
//  TO - DO LIST
//
//  Created by Anastasia on 08.04.2026.
//
//
import UIKit

class TabBarController: UITabBarController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createTabBar()
        setTabBarAppearance()
    }
}
// MARK: TabBar

extension TabBarController {
    
    func createTabBar() {
        viewControllers = [
            createVC(
                viewController: UINavigationController(rootViewController:  MainViewController()),
                title: "Tasks",
                image: UIImage(systemName: "list.bullet.clipboard.fill")
            ),
            createVC(
                viewController: SettingsViewController(),
                title: "Settings",
                image: UIImage(systemName: "gearshape.fill")
            )
        ]
    }
    
    func createVC(viewController: UIViewController, title: String, image: UIImage?) -> UIViewController {
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = image
        return viewController
    }
    
    private func setTabBarAppearance() {
        
//        let positionOnX: CGFloat = 40
//        let positionOnY: CGFloat = 14
//        let width = tabBar.bounds.width / 2
//        let height = tabBar.bounds.height
//        
//        let roundLayer = CAShapeLayer()
//        
//        let bezierPath = UIBezierPath(
//            roundedRect: CGRectMake(
//                positionOnX,
//                tabBar.bounds.minY - positionOnY,
//                width,
//                height
//            ), cornerRadius: height / 3
//        )
//        roundLayer.path = bezierPath.cgPath
//        tabBar.layer.insertSublayer(roundLayer, at: 0)
//        tabBar.itemWidth = width / 3
//        tabBar.itemPositioning = .centered
//        roundLayer.fillColor = .none
        tabBar.tintColor = .doneGreen

    }
}
