//
//  SessionModel.swift
//  FitnessTrackerMVP
//
//  Created by macbook on 15.01.2023.
//

import UIKit

protocol SessionModelProtocol {
    var presenter: SessionPresenterProtocol? { get set }
}

class SessionModel: SessionModelProtocol {
    var presenter: SessionPresenterProtocol?
}
