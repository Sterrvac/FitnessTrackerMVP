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

class MainPresenter: MainPresenterProtocol {
    
    var view: MainViewProtocol?
    
    var model: MainModelProtocol?
}
