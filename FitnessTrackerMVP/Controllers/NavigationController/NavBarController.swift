//
//  NavBarController.swift
//  FitnessTrackerMPV
//
//  Created by macbook on 12.01.2023.
//

import UIKit

final class NavBarController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurateAppearance()
    }
    
    private func configurateAppearance() {
        view.backgroundColor = .white
        navigationBar.isTranslucent = false
        navigationBar.standardAppearance.titleTextAttributes = [
            .foregroundColor: R.Colors.titleGray,
            .font: R.Fonts.helvelicaRegular(with: 17),
        ]
        
        navigationBar.addBottomBorder(with: R.Colors.separator, height: 1)
    }
    
}
