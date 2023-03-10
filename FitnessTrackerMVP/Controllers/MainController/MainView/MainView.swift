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

class MainView: MainViewController, MainViewProtocol, UITableViewDataSource {
    var presenter: MainPresenterProtocol?
    
    let navBar = MainViewNavBar()

    override func setupViews() {
        super.setupViews()
        
        view.setupView(navBar)
        view.setupView(table)
        table.dataSource = self
        contraintAddButton()
    }

    override func contraintViews() {
        super.contraintViews()

        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: view.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            table.topAnchor.constraint(equalTo: navBar.bottomAnchor),
            table.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            table.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
    
    func contraintAddButton() {
        navBar.addAdditingAction(#selector(button), self)
    }

    override func configurateAppearance() {
        super.configurateAppearance()

        navigationController?.navigationBar.isHidden = true
        
    }
}

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
    
    @objc func button() {
        print("ok")
        let alert = UIAlertController(title: "Alert", message: "Are you sure you want to delete this?", preferredStyle: .alert)
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Type in alert"})
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] (_) in
            if let filed = alert.textFields?.first {
                if let text = filed.text, !text.isEmpty {
                    DispatchQueue.main.async {
                        self?.items.append(text)
                        self?.table.reloadData()
                    }
                }
            }
        }))

        present(alert, animated: true)
    }
}

//MARK: - MainView

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

class MainViewNavBar: View {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = R.Strings.NavBar.view
        label.textColor = R.Colors.titleGray
        label.font = R.Fonts.helvelicaRegular(with: 22)
        return label
    }()
    
    let addButton: UIButton = {
        let button = UIButton()
        button.setImage(R.Images.Common.add, for: .normal)
        button.addTarget(nil, action: #selector(addAdditingAction), for: .touchUpInside)
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
    
    @objc func addAdditingAction(_ action: Selector, _ target: Any?) {
        addButton.addTarget(nil, action: action, for: .touchUpInside)
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

class WeekView: View {

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
    final class WeekdayView: View {
        
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

//MARK: - BarsMainView

class BarsView: View {
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.distribution = .fillEqually
        return view
    }()
    
    func configurate(with data: [BarView.Data]) {
        data.forEach {
            let barView = BarView(data: $0)
            stackView.addArrangedSubview(barView)
        }
    }
}

extension BarsView {
    override func setupViews() {
        super.setupViews()
        
        setupView(stackView)
    }
    
    override func constraintViews() {
        super.constraintViews()
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    override func configurateAppearance() {
        super.configurateAppearance()
        
        backgroundColor = .clear
    }
}

class BarView: View {
    
    private let heightMultiplier: Double
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = R.Fonts.helvelicaRegular(with: 13)
        label.textColor = R.Colors.active
        
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = R.Fonts.helvelicaRegular(with: 9)
        label.textColor = R.Colors.inactive
        
        return label
    }()
    
    private let barView: UIView = {
        let view = UIView()
        view.backgroundColor = R.Colors.active
        view.layer.cornerRadius = 2.5
        
        return view
    }()
    
    init(data: Data) {
        self.heightMultiplier = data.heightMultiplier
        super.init(frame: .zero)
        
        titleLabel.text = data.title.uppercased()
        valueLabel.text = data.value
    }
    
    required init?(coder: NSCoder) {
        self.heightMultiplier = 0
        super.init(frame: .zero)
    }
    
}


extension BarView {
    override func setupViews() {
        super.setupViews()
        
        setupView(valueLabel)
        setupView(titleLabel)
        setupView(barView)
    }
    
    override func constraintViews() {
        super.constraintViews()

        NSLayoutConstraint.activate([
            valueLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            valueLabel.heightAnchor.constraint(equalToConstant: 10),
            
            barView.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 5),
            barView.centerXAnchor.constraint(equalTo: centerXAnchor),
            barView.widthAnchor.constraint(equalToConstant: 17),
            barView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: heightMultiplier * 0.8),
            
            titleLabel.topAnchor.constraint(equalTo: barView.bottomAnchor, constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 10),
        ])
    }
    
    override func configurateAppearance() {
        super.configurateAppearance()
        
        backgroundColor = .clear
    }
}

