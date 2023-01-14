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

//MARK: - MainViewController

class MainViewController: UIViewController, MainViewProtocol {
    
    var presenter: MainPresenterProtocol?
    
    let navBar = MainViewNavBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        contraintViews()
        configurateAppearance()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        view.setupView(navBar)
        
        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: view.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        navigationController?.navigationBar.isHidden = true
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

//class ViewController: MainViewController {
//
//    override func setupViews() {
//        self.setupViews()
//
//    }
//
//    override func contraintViews() {
//        self.contraintViews()
//
//        NSLayoutConstraint.activate([
//            navBar.topAnchor.constraint(equalTo: view.topAnchor),
//            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//        ])
//    }
//
//    override func configurateAppearance() {
//        self.configurateAppearance()
//
//        navigationController?.navigationBar.isHidden = true
//
//    }
//}

extension MainViewController {
    enum NavBarPosition {
        case left
        case right
    }
    
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

//MARK: - MainView

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

@objc extension MainView {
    func setupViews() {}
    func constraintViews() {}
    
    func configurateAppearance() {
        backgroundColor = .white
    }
}

class MainInfoView: MainView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = R.Fonts.helvelicaRegular(with: 13)
        label.textColor = R.Colors.inactive
        return label
    }()
    
    private let button = MainButton(with: .primary)
    
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

extension MainInfoView {
    override func setupViews() {
        super.setupViews()
        
        setupView(titleLabel)
        setupView(button)
        setupView(contentView)
    }
    
    override func constraintViews() {
        super.constraintViews()
        
        let contentTopAnchor: NSLayoutAnchor = titleLabel.text == nil ? topAnchor : titleLabel.bottomAnchor
        let contentTopOffset: CGFloat = titleLabel.text == nil ? 0 : 10
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            button.trailingAnchor.constraint(equalTo: trailingAnchor),
            button.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            button.heightAnchor.constraint(equalToConstant: 28),
            
            contentView.topAnchor.constraint(equalTo: contentTopAnchor, constant: contentTopOffset),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    override func configurateAppearance() {
        super.configurateAppearance()
        
        backgroundColor = .clear
    }
}

//MARK: - MainViewNavBar

final class MainViewNavBar: MainView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = R.Strings.NavBar.view
        label.textColor = R.Colors.titleGray
        label.font = R.Fonts.helvelicaRegular(with: 22)
        return label
    }()
    
    private let addButton: UIButton = {
        let button = UIButton()
        button.setImage(R.Images.Common.add, for: .normal)
        return button
    }()
    
    private let allWorkoutsButton: MainButton = {
        let button = MainButton(with: .secondary)
        button.setTitle(R.Strings.View.allWorkoutsButton)
        return button
    }()
    
    private let weekView = WeekView()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addBottomBorder(with: R.Colors.separator, height: 1)
    }
    
    func addAllWorkoutsAction(_ action: Selector, with target: Any?) {
        allWorkoutsButton.addTarget(target, action: action, for: .touchUpInside)
    }
    func addAdditingAction(_ action: Selector, with target: Any?) {
        addButton.addTarget(target, action: action, for: .touchUpInside)
    }
}

extension MainViewNavBar {
    override func setupViews() {
        super.setupViews()
        
        setupView(titleLabel)
        setupView(addButton)
        setupView(allWorkoutsButton)
        setupView(weekView)
    }
    
    override func constraintViews() {
        super.constraintViews()
        
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
            addButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            addButton.heightAnchor.constraint(equalToConstant: 28),
            addButton.widthAnchor.constraint(equalToConstant: 28),
            
            allWorkoutsButton.topAnchor.constraint(equalTo: addButton.topAnchor),
            allWorkoutsButton.trailingAnchor.constraint(equalTo: addButton.leadingAnchor, constant: -15),
            allWorkoutsButton.heightAnchor.constraint(equalToConstant: 28),
            
            titleLabel.centerYAnchor.constraint(equalTo: allWorkoutsButton.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: allWorkoutsButton.leadingAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            
            weekView.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 15),
            weekView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            weekView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            weekView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            weekView.heightAnchor.constraint(equalToConstant: 47),
        ])
    }
    
    override func configurateAppearance() {
        super.configurateAppearance()
        backgroundColor = .white
        
        titleLabel.text = R.Strings.NavBar.view
        titleLabel.textColor = R.Colors.titleGray
        titleLabel.font = R.Fonts.helvelicaRegular(with: 22)
        
        addButton.setImage(R.Images.Common.add, for: .normal)
        
        allWorkoutsButton.setTitle(R.Strings.View.allWorkoutsButton)
    }
}

final class WeekView: MainView {

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 7
        stackView.distribution = .fillEqually
        return stackView
    }()
}

extension WeekView {
    override func setupViews() {
        super.setupViews()
        
        setupView(stackView)
    }
    
    override func constraintViews() {
        super.constraintViews()
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    override func configurateAppearance() {
        super.configurateAppearance()
                
        var weekdays = Date.calendar.shortStandaloneWeekdaySymbols
        
        if Date.calendar.firstWeekday == 2 {
            let sun = weekdays.remove(at: 0)
            weekdays.append(sun)
        }
        
        weekdays.enumerated().forEach { index, name in
            let view = WeekdayView()
            
            view.configurate(with: index, and: name)
            stackView.addArrangedSubview(view)
        }
    }
}

extension WeekView {
    final class WeekdayView: MainView {
        
        private let nameLabel: UILabel = {
            let label = UILabel()
            label.font = R.Fonts.helvelicaRegular(with: 9)
            label.textAlignment = .center
            
            return label
        }()
        
        private let dateLabel:  UILabel = {
            let label = UILabel()
            label.font = R.Fonts.helvelicaRegular(with: 15)
            label.textAlignment = .center
            
            return label
        }()
        
        private let stackView: UIStackView = {
            let view = UIStackView()
            view.spacing = 3
            view.axis = .vertical
            
            return view
        }()
        
        
        func configurate(with index: Int, and name: String) {
            let startOfWeek = Date().startOfWeek
            let currentDay = startOfWeek.agoForward(to: index)
            let day = Date.calendar.component(.day, from: currentDay)
            
            let isToday = currentDay.stripTime() == Date().stripTime()
            
            backgroundColor = isToday ? R.Colors.active : R.Colors.background
            
            nameLabel.text = name.uppercased()
            nameLabel.textColor = isToday ? .white : R.Colors.inactive
            
            dateLabel.text = "\(day)"
            dateLabel.textColor = isToday ? .white : R.Colors.inactive
        }
    }
}

extension WeekView.WeekdayView {
    override func setupViews() {
        super.setupViews()
        
        setupView(stackView)
        
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(dateLabel)
    }
    
    override func constraintViews() {
        super.constraintViews()
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    override func configurateAppearance() {
        super.configurateAppearance()
                
        layer.cornerRadius = 5
        layer.masksToBounds = true
    }
}


//MARK: - MainButton

class MainButton: UIButton {
    enum ButtonType {
        case primary
        case secondary
    }
    
    private var type: ButtonType = .primary
    
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    private let iconView: UIImageView = {
        let view = UIImageView()
        view.image = R.Images.Common.downArrow?.withRenderingMode(.alwaysTemplate)
        return view
    }()
    
    init(with type: ButtonType) {
        super.init(frame: .zero)
        self.type = type
        
        setupViews()
        constraintViews()
        configurateAppearance()
    }
    
    required init?(coder: NSCoder) {
        super.init(frame: .zero)
        
        setupViews()
        constraintViews()
        configurateAppearance()
    }
    
    func setTitle(_ title: String?) {
        label.text = title
    }
}

private extension MainButton {
    func setupViews() {
        setupView(label)
        setupView(iconView)
    }
    
    func constraintViews() {
        var horisontalOffset: CGFloat {
            switch type {
            case .primary: return 0
            case .secondary: return 10
            }
        }
        
        NSLayoutConstraint.activate([
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -horisontalOffset),
            iconView.heightAnchor.constraint(equalToConstant: 5),
            iconView.widthAnchor.constraint(equalToConstant: 10),
            
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.trailingAnchor.constraint(equalTo: iconView.leadingAnchor, constant: -10),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horisontalOffset * 2)
        ])
    }
    
    func configurateAppearance() {
        switch type {
        case .primary:
            label.textColor = R.Colors.inactive
            label.font = R.Fonts.helvelicaRegular(with: 13)
            
            iconView.tintColor = R.Colors.inactive
        case .secondary:
            backgroundColor = R.Colors.secondary
            layer.cornerRadius = 15
            
            label.font = R.Fonts.helvelicaRegular(with: 15)
            label.textColor = R.Colors.active
            
            iconView.tintColor = R.Colors.active
        }
        makeSystem(self)
    }
}
