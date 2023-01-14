//
//  SettingsViewController.swift
//  FitnessTrackerMPV
//
//  Created by macbook on 12.01.2023.
//

import UIKit

protocol SettingsViewProtocol {
    
}

class SettingsViewController: MainViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = R.Strings.NavBar.settings
    }
}

extension SettingsViewController {
    override func setupViews() {
        super.setupViews()
    }
    
    override func contraintViews() {
        super.contraintViews()
    }
    
    override func configurateAppearance() {
        super.configurateAppearance()
        
        title = R.Strings.NavBar.settings
    }
}
