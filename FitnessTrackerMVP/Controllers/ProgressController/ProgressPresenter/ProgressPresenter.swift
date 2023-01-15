//
//  ProgressPresenter.swift
//  FitnessTrackerMVP
//
//  Created by macbook on 15.01.2023.
//

import UIKit

protocol ProgressPresenterProtocol {
    var view: ProgressViewProtocol? { get set }
    var model: ProgressModelProtocol? { get set }
}

class ProgressPresenter: ProgressPresenterProtocol {
    
    var view: ProgressViewProtocol?
    
    var model: ProgressModelProtocol?
}
