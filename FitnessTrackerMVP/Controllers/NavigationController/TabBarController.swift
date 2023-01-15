//
//  tabBarController.swift
//  FitnessTrackerMPV
//
//  Created by macbook on 12.01.2023.
//

import UIKit

enum Tabs: Int, CaseIterable {
    case view
    case session
    case progress
    case settings
}

final class TabBarController: UITabBarController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        configurateAppearance()
        swichTo(tab: .view)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configurateAppearance()
    }
    
    func swichTo(tab: Tabs) {
        selectedIndex = tab.rawValue
    }
    
    private func configurateAppearance() {
        tabBar.tintColor = R.Colors.active
        tabBar.barTintColor = .white
        tabBar.backgroundColor = .white
        
        tabBar.layer.borderColor = R.Colors.separator.cgColor
        tabBar.layer.borderWidth = 1
        tabBar.layer.masksToBounds = true
        
        let controllers: [NavBarController] = Tabs.allCases.map { tab in
            let controller = NavBarController(rootViewController: getController(for: tab))
            controller.tabBarItem = UITabBarItem(title: R.Strings.TabBar.title(for: tab),
                                                 image: R.Images.TabBar.icon(for: tab),
                                                 tag: tab.rawValue)
            return controller
        }

        setViewControllers(controllers, animated: false)
        
    }
    
    private func getController(for tab: Tabs) -> UIViewController {
        switch tab {
        case .view: return MainView()
        case .session: return SessionViewController()
        case .progress: return ProgressViewController()
        case .settings: return SettingsViewController()
        }
    }
}
