//
//  ProgressModel.swift
//  FitnessTrackerMVP
//
//  Created by macbook on 15.01.2023.
//

import UIKit

protocol ProgressModelProtocol {
    var progress: ProgressPresenterProtocol? { get set }
}

class ProgressModel: ProgressModelProtocol {
    
    var progress: ProgressPresenterProtocol?
    
}
