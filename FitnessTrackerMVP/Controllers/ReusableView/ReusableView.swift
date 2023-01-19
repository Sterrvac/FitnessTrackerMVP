//
//  ReusableView.swift
//  FitnessTrackerMVP
//
//  Created by macbook on 15.01.2023.
//

import UIKit

protocol BaseViewProtocol {
    var mainPresenter: MainPresenterProtocol? { get set }
    var sessionPresenter: SessionPresenterProtocol? { get set }
    var progressPresenter: ProgressPresenterProtocol? { get set }
    var settingsPresenter: SettingsPresenterProtocol? { get set }
}

class MainViewController: UIViewController, BaseViewProtocol {
    
    var mainPresenter: MainPresenterProtocol?
    
    var sessionPresenter: SessionPresenterProtocol?
    
    var progressPresenter: ProgressPresenterProtocol?
    
    var settingsPresenter: SettingsPresenterProtocol?
    
    var items = [String]()
    
    let table: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self,
                       forCellReuseIdentifier: "cell")
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        contraintViews()
        configurateAppearance()
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

class View: UIView, BaseViewProtocol {
    
    var mainPresenter: MainPresenterProtocol?
    
    var sessionPresenter: SessionPresenterProtocol?
    
    var progressPresenter: ProgressPresenterProtocol?
    
    var settingsPresenter: SettingsPresenterProtocol?
    
    struct Data {
        let value: String
        let heightMultiplier: Double
        let title: String
    }
    
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

@objc extension View {
    func setupViews() {}
    func constraintViews() {}
    
    func configurateAppearance() {
        backgroundColor = .white
    }
}

class MainInfoView: View {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = R.Fonts.helvelicaRegular(with: 13)
        label.textColor = R.Colors.inactive
        return label
    }()
    
    let button = MainButton(with: .primary)
    
    let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderColor = R.Colors.separator.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 5
        
        return view
    }()
    
    init(with title: String? = nil, buttonTitle: String? = nil) {
        titleLabel.text = title?.uppercased()
        titleLabel.textAlignment = buttonTitle == nil ? .center : .left
        
        button.setTitle(buttonTitle?.uppercased())
        button.isHidden = buttonTitle == nil ? true : false
        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        super.init(frame: .zero)
    }
    
    func addButtonTarget(target: Any?, action: Selector) {
        button.addTarget(action, action: action, for: .touchUpInside)
    }
}

