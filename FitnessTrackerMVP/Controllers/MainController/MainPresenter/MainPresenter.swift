//
//  MainPresenterController.swift
//  FitnessTrackerMVP
//
//  Created by macbook on 12.01.2023.
//

import UIKit

protocol MainPresenterProtocol {
    var view: MainViewProtocol? { get set }
    var model: MainModelProtocol? { get set }
    
    
}

class MainPresenterController: MainPresenterProtocol {
    
    var view: MainViewProtocol?
    
    var model: MainModelProtocol?
    
}

class MainView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        constraintViews()
        configurateAppearance()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupViews()
        constraintViews()
        configurateAppearance()
    }
}
