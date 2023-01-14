//
//  ViewController.swift
//  FitnessTrackerMPV
//
//  Created by macbook on 12.01.2023.
//

import UIKit

protocol MainViewProtocol {
    var presenter: MainPresenterProtocol? { get set }
}

enum NavBarPosition {
    case left
    case right
}

class MainViewController: UIViewController, MainViewProtocol {
    
    var presenter: MainPresenterProtocol?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        contraintViews()
        configurateAppearance()
    }
}

@objc extension MainView {
    func setupViews() {}
    func constraintViews() {}
    
    func configurateAppearance() {
        backgroundColor = .white
    }
}

@objc extension MainViewController {
    
    func setupViews() {}
    func contraintViews() {}
    
    func configurateAppearance() {
        view.backgroundColor = R.Colors.background
    }

    func navBarLeftButtonHandler() {
        print("NavBar left button tapped")
    }
    
    func navBarRightButtonHandler() {
        print("NavBar right button tapped")
    }
}

extension MainViewController {
    func addNavBarButton(at position: NavBarPosition, wigh title: String) {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(R.Colors.active, for: .normal)
        button.setTitleColor(R.Colors.inactive, for: .disabled)
        button.titleLabel?.font = R.Fonts.helvelicaRegular(with: 17)
        
        switch position {
        case .left:
            button.addTarget(self, action: #selector(navBarLeftButtonHandler), for: .touchUpInside)
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        case .right:
            button.addTarget(self, action: #selector(navBarRightButtonHandler), for: .touchUpInside)
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        }
    }
}
