//
//  MainModelController.swift
//  FitnessTrackerMVP
//
//  Created by macbook on 13.01.2023.
//

import UIKit

protocol MainModelProtocol {
    var presenter: MainPresenterProtocol? { get set }
}

class MainModelController: MainModelProtocol {
    
    var presenter: MainPresenterProtocol?
    
}

