//
//  SeesionPresenter.swift
//  FitnessTrackerMVP
//
//  Created by macbook on 15.01.2023.
//

import UIKit

protocol SessionPresenterProtocol {
    var view: SessionViewProtocol? { get set }
    var model: SessionModelProtocol? { get set }
    var baseView: BaseViewProtocol? { get set }
}

class SessionPresenter: SessionPresenterProtocol {
    var baseView: BaseViewProtocol?
    
    var view: SessionViewProtocol?
    
    var model: SessionModelProtocol?
}
