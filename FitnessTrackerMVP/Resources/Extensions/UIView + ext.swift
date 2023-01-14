//
//  UIView + ext.swift
//  FitnessTrackerMPV
//
//  Created by macbook on 12.01.2023.
//

import UIKit

extension UIView {
    @objc func setupView(_ view: UIView) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
    }
}
