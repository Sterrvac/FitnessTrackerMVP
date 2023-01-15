//
//  SessionView.swift
//  FitnessTrackerMPV
//
//  Created by macbook on 12.01.2023.
//

import UIKit

protocol SessionViewProtocol {
    var presenter: SessionPresenterProtocol? { get set }
    var baseView: BaseViewProtocol? { get set }
}

//MARK: - SessionViewController

class SessionView: MainViewController, SessionViewProtocol {
    
    var baseView: BaseViewProtocol?
    
    var presenter: SessionPresenterProtocol?
    
    private let timerView = TimerView()
    private let statsView = StatsView(with: R.Strings.Session.workoutState)
    private let stepsView = StepsView(with: R.Strings.Session.stepsCounter)
    
    private let contentView: UIStackView = {
        let view = UIStackView()
        view.isLayoutMarginsRelativeArrangement = true
        view.axis = .vertical
        
        return view
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = true
        
        return scrollView
    }()
    
    private let timerDuration = 5.0
    
    override func navBarLeftButtonHandler() {
        if timerView.state == .isStopped {
            timerView.startTimer()
        } else {
            timerView.pauseTimer()
        }
        
        timerView.state = timerView.state == .isRuning ? .isStopped : .isRuning
        
        addNavBarButton(at: .left,
                        wigh: timerView.state == .isRuning ? R.Strings.Session.navBarPause : R.Strings.Session.navBarStart)
    }
    
    override func navBarRightButtonHandler() {
        timerView.stopTimer()
        timerView.state = .isStopped
    
        addNavBarButton(at: .left,
                        wigh: R.Strings.Session.navBarStart)
    }
}

extension SessionView {
    override func setupViews() {
        super.setupViews()
        
        contentView.setupView(timerView)
        contentView.setupView(statsView)
        contentView.setupView(stepsView)
        
        scrollView.setupView(contentView)
        
        view.setupView(scrollView)
    }
    
    override func contraintViews() {
        super.contraintViews()
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            timerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            timerView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 15),
            timerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
        
            statsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 15),
            statsView.topAnchor.constraint(equalTo: timerView.bottomAnchor, constant: 10),
            statsView.trailingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -5.5),
            statsView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            
            stepsView.leadingAnchor.constraint(equalTo: contentView.centerXAnchor,constant: 5.5),
            stepsView.topAnchor.constraint(equalTo: statsView.topAnchor),
            stepsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            stepsView.heightAnchor.constraint(equalTo: statsView.heightAnchor),
        ])
    }
    
    override func configurateAppearance() {
        super.configurateAppearance()
        
        title = R.Strings.NavBar.session
        navigationController?.tabBarItem.title = R.Strings.TabBar.title(for: .session)
        
        addNavBarButton(at: .left, wigh: R.Strings.Session.navBarStart)
        addNavBarButton(at: .right, wigh: R.Strings.Session.navBarFinish)
        
        timerView.configurate(with: timerDuration, progress: 0)
        timerView.callBack = { [weak self] in
            self?.navBarRightButtonHandler()
        }
        
        statsView.configurate(with: [.heartRate(value: "155"),
                                     .averagePace(value: "9'20''"),
                                     .totalSteps(value: "7,682"),
                                     .totalDistance(value: "8,25")])
        
        stepsView.configurate(with: [.init(value: "8k", heightMultiplier: 1, title: "2/14"),
                                     .init(value: "7k", heightMultiplier: 0.8, title: "2/15"),
                                     .init(value: "5k", heightMultiplier: 0.6, title: "2/16"),
                                     .init(value: "6k", heightMultiplier: 0.7, title: "2/17")])
    }
}

//MARK: - TimerSessionView

class TimerView: MainInfoView {
    
    private let elapsedTimeLabel: UILabel = {
        let label = UILabel()
        label.text = R.Strings.Session.elapsedTime
        label.font = R.Fonts.helvelicaRegular(with: 14)
        label.textColor = R.Colors.inactive
        label.textAlignment = .center
        
        return label
    }()
    
    private let elapsedTimeValueLabel: UILabel = {
        let label = UILabel()
        label.font = R.Fonts.helvelicaRegular(with: 46)
        label.textColor = R.Colors.titleGray
        label.textAlignment = .center
        
        return label
    }()
    
    private let remainingTimeLabel: UILabel = {
        let label = UILabel()
        label.text = R.Strings.Session.remainingTime
        label.font = R.Fonts.helvelicaRegular(with: 13)
        label.textColor = R.Colors.inactive
        label.textAlignment = .center
        
        return label
    }()
    
    private let remainingTimeValueLabel: UILabel = {
        let label = UILabel()
        label.font = R.Fonts.helvelicaRegular(with: 13)
        label.textColor = R.Colors.titleGray
        label.textAlignment = .center
        
        return label
    }()
    
    private let timeStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fillProportionally
        view.spacing = 10
        
        return view
    }()
    
    private let bottomStackView: UIStackView = {
        let view = UIStackView()
        view.distribution = .fillProportionally
        view.spacing = 5
        
        return view
    }()
    
    private let completedPercentView = PercentView()
    private let remainingPercentView = PercentView()
    
    private let bottomSeporatorView: UIView = {
        let view = UIView()
        view.backgroundColor = R.Colors.separator
        
        return view
    }()
    
    private let progressView = ProgressView()
    
    private var timer = Timer()
    private var timerProgress: CGFloat = 0
    private var timerDuration = 0.0
    
    var state: TimerState = .isStopped
    var callBack: (() -> Void)?
    
    func configurate(with duration: Double, progress: Double) {
        timerDuration = duration
        
        let tempCurrentValue = progress > duration ? duration : progress
        
        let goalValueDevider = duration == 0 ? 1 : duration
        let percent = tempCurrentValue / goalValueDevider
        
        let roundedPercent = Int(round(percent * 100))
        
        elapsedTimeValueLabel.text = getDisplayedString(from: Int(tempCurrentValue))
        remainingTimeValueLabel.text = getDisplayedString(from: Int(duration) - Int(tempCurrentValue))
        
        completedPercentView.configurate(with: "Completed", andValue: roundedPercent)
        remainingPercentView.configurate(with: "Remining", andValue: 100 - roundedPercent)
        
        progressView.drawProgress(with: CGFloat(percent))
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.01,
                                     repeats: true,
                                     block: { [weak self] timer in
            guard let self = self else { return }
            
            self.timerProgress += 0.01
            if self.timerProgress > self.timerDuration {
                self.timerProgress = self.timerDuration
                timer.invalidate()
            }
            
            self.configurate(with: self.timerDuration,
                             progress: self.timerProgress)
        })
    }
    
    func pauseTimer() {
        timer.invalidate()
    }
    
    func stopTimer() {
        guard self.timerProgress > 0 else { return }
        timer.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.01,
                                     repeats: true,
                                     block: { [weak self] timer in
            guard let self = self else { return }
            
            self.timerProgress -= self.timerDuration * 0.02
            
            if self.timerProgress <= 0 {
                self.timerProgress = 0
                timer.invalidate()
            }
            
            self.configurate(with: self.timerDuration,
                             progress: self.timerProgress)
        })
        

    }
}

extension TimerView {
    override func setupViews() {
        super.setupViews()
        
        setupView(progressView)
        setupView(timeStackView)
        setupView(bottomStackView)
        
        [
            elapsedTimeLabel,
            elapsedTimeValueLabel,
            remainingTimeLabel,
            remainingTimeValueLabel,
        ].forEach(timeStackView.addArrangedSubview)
        [
            completedPercentView,
            bottomSeporatorView,
            remainingPercentView,
        ].forEach(bottomStackView.addArrangedSubview)
    }
    
    override func constraintViews() {
        super.constraintViews()
        
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: topAnchor, constant: 40),
            progressView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            progressView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            progressView.heightAnchor.constraint(equalTo: progressView.widthAnchor),
            progressView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -40),
            
            timeStackView.centerYAnchor.constraint(equalTo: progressView.centerYAnchor),
            timeStackView.centerXAnchor.constraint(equalTo: progressView.centerXAnchor),
            
            bottomStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -28),
            bottomStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            bottomStackView.heightAnchor.constraint(equalToConstant: 35),
            bottomStackView.widthAnchor.constraint(equalToConstant: 175),
            
            bottomSeporatorView.widthAnchor.constraint(equalToConstant: 1),
        ])
    }
    
    override func configurateAppearance() {
        super.configurateAppearance()
    }
}

//MARK: - ProgressSessionView

extension TimerView {
    
    class ProgressView: UIView {
        func drawProgress(with percent: CGFloat) {
            layer.sublayers?.removeAll()
            
            let circleFrame = UIScreen.main.bounds.width - (15 + 40) * 2
            let radius = circleFrame / 2
            let center = CGPoint(x: radius, y: radius)
            let startAngle = -CGFloat.pi * 7 / 6
            let endAngle = CGFloat.pi * 1 / 6
            
            let circlePath = UIBezierPath(arcCenter: center,
                                          radius: radius,
                                          startAngle: startAngle,
                                          endAngle: endAngle,
                                          clockwise: true)
            
            let defaultCircleLayer = CAShapeLayer()
            defaultCircleLayer.path = circlePath.cgPath
            defaultCircleLayer.strokeColor = R.Colors.separator.cgColor
            defaultCircleLayer.lineWidth = 20
            defaultCircleLayer.strokeEnd = 1
            defaultCircleLayer.fillColor = UIColor.clear.cgColor
            defaultCircleLayer.lineCap = .round
            
            let circleLayer = CAShapeLayer()
            circleLayer.path = circlePath.cgPath
            circleLayer.strokeColor = R.Colors.active.cgColor
            circleLayer.lineWidth = 20
            circleLayer.strokeEnd = percent
            circleLayer.fillColor = UIColor.clear.cgColor
            circleLayer.lineCap = .round
            
            let dotAngle = CGFloat.pi * (7 / 6 - (8 / 6 * percent))
            let dotPoint = CGPoint(x: cos(-dotAngle) * radius + center.x,
                                   y: sin(-dotAngle) * radius + center.y)
            
            let dotPath = UIBezierPath()
            dotPath.move(to: dotPoint)
            dotPath.addLine(to: dotPoint)
            
            let bigDotLayer = CAShapeLayer()
            bigDotLayer.path = dotPath.cgPath
            bigDotLayer.fillColor = UIColor.clear.cgColor
            bigDotLayer.strokeColor = R.Colors.active.cgColor
            bigDotLayer.lineCap = .round
            bigDotLayer.lineWidth = 20
            
            let dotLayer = CAShapeLayer()
            dotLayer.path = dotPath.cgPath
            dotLayer.fillColor = UIColor.clear.cgColor
            dotLayer.strokeColor = UIColor.white.cgColor
            dotLayer.lineCap = .round
            dotLayer.lineWidth = 10
            
            let barsFrame = UIScreen.main.bounds.width - (15 + 40 + 25) * 2
            let barsRadius = barsFrame / 2
            
            let barsPath = UIBezierPath(arcCenter:center,
                                        radius: barsRadius,
                                        startAngle: startAngle,
                                        endAngle: endAngle,
                                        clockwise: true)
            
            let barsLayer = CAShapeLayer()
            barsLayer.path = barsPath.cgPath
            barsLayer.fillColor = UIColor.clear.cgColor
            barsLayer.strokeColor = UIColor.white.cgColor
            barsLayer.lineWidth = 8
            
            let startBarRadius = barsRadius - barsLayer.lineWidth * 0.5
            let endBarRaious = startBarRadius + 6
            
            var angle: CGFloat = 7 / 6
            (1...9).forEach { _ in
                let barAngle = CGFloat.pi * angle
                let startBarPoint = CGPoint (
                x: cos(-barAngle) * startBarRadius + center.x,
                y: sin(-barAngle) * startBarRadius + center.y
                )
                
                let endBarPoint = CGPoint (
                    x: cos(-barAngle) * endBarRaious + center.x,
                    y: sin(-barAngle) * endBarRaious + center.y
                )
                
                let barPath = UIBezierPath()
                barPath.move(to: startBarPoint)
                barPath.addLine(to: endBarPoint)
                
                let barLayer = CAShapeLayer()
                barLayer.path = barPath.cgPath
                barLayer.fillColor = UIColor.clear.cgColor
                barLayer.strokeColor = angle >= (7 / 6 - (8 / 6 * percent)) ? R.Colors.active.cgColor : R.Colors.separator.cgColor
                barLayer.lineCap = .round
                barLayer.lineWidth = 4
                
                barsLayer.addSublayer(barLayer)
                
                angle -= 1 / 6
            }
            
            layer.addSublayer(defaultCircleLayer)
            layer.addSublayer(circleLayer)
            layer.addSublayer(bigDotLayer)
            layer.addSublayer(dotLayer)
            layer.addSublayer(barsLayer)
        }
    }
    
    func getDisplayedString(from value: Int) -> String {
        let seconds = value % 60
        let minutes = (value / 60) % 60
        let hours = value / 3600
        
        let secondsStr = seconds < 10 ? "0\(seconds)" : "\(seconds)"
        let minutesStr = minutes < 10 ? "0\(minutes)" : "\(minutes)"
        let hoursStr = hours < 10 ? "0\(hours)" : "\(hours)"
        
        return hours == 0 ? [minutesStr, secondsStr].joined(separator: ":")
        : [hoursStr, minutesStr, secondsStr].joined(separator: ":")
    }
}

//MARK: - PercentSessionView

extension TimerView {
    
    enum TimerState {
        case isRuning
        case isPaused
        case isStopped
    }
    
    final class PercentView: View {
        
        private let stackView: UIStackView = {
            let view = UIStackView()
            view.axis = .vertical
            view.distribution = .fillProportionally
            view.spacing = 5
            
            return view
        }()
        
        private let percentLabel: UILabel = {
            let label = UILabel()
            label.font = R.Fonts.helvelicaRegular(with: 23)
            label.textColor = R.Colors.titleGray
            label.textAlignment = .center
            
            return label
        }()
        
        private let subtitleLabel: UILabel = {
            let label = UILabel()
            label.font = R.Fonts.helvelicaRegular(with: 10)
            label.textColor = R.Colors.inactive
            label.textAlignment = .center
            
            return label
        }()
        
        override func setupViews() {
            super.setupViews()
            
            setupView(stackView)
            
            stackView.addArrangedSubview(percentLabel)
            stackView.addArrangedSubview(subtitleLabel)
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
        
        func configurate(with title: String ,andValue value: Int) {
            subtitleLabel.text = title
            percentLabel.text = "\(value)"
        }
    }
}

//MARK: - StatsSessionView

class StatsView: MainInfoView {
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 15
        return view
    }()
    
    func configurate(with items: [StatsItem]) {
        items.forEach {
            let itemView = StatsItemView()
            itemView.configurate(with: $0)
            stackView.addArrangedSubview(itemView)
        }
    }
}

extension StatsView {
    override func setupViews() {
        super.setupViews()
        
        setupView(stackView)
    }
    
    override func constraintViews() {
        super.constraintViews()
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
        ])
    }
    
    override func configurateAppearance() {
        super.configurateAppearance()
    }
}

enum StatsItem {
    case averagePace(value: String)
    case heartRate(value: String)
    case totalDistance(value: String)
    case totalSteps(value: String)
    
    var itemData: StatsItemView.ItemData {
        switch self {
        case .heartRate(let value) : return .init(image: R.Images.Session.heartRate,
                                                    value: "\(value) bpm",
                                                    title: R.Strings.Session.heartRate)
        case .averagePace(let value) : return .init(image: R.Images.Session.averagePace,
                                                    value: "\(value) / km",
                                                    title: R.Strings.Session.averagePace)
        case .totalSteps(let value) : return .init(image: R.Images.Session.totalSteps,
                                                    value: "\(value)",
                                                    title: R.Strings.Session.totalSteps)
        case .totalDistance(let value) : return .init(image: R.Images.Session.totalDistance,
                                                    value: "\(value) km",
                                                    title: R.Strings.Session.totalDistance)
        }
    }
}

final class StatsItemView: View {
    
    struct ItemData {
        let image: UIImage?
        let value: String
        let title: String
    }
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        
        return view
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = R.Fonts.helvelicaRegular(with: 20)
        label.textColor = R.Colors.titleGray
        
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = R.Fonts.helvelicaRegular(with: 13)
        label.textColor = R.Colors.inactive
        
        return label
    }()
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        
        return view
    }()
    
    func configurate(with item: StatsItem) {
        imageView.image = item.itemData.image
        valueLabel.text = item.itemData.value
        titleLabel.text = item.itemData.title.uppercased()
    }
    
}

extension StatsItemView {
    override func setupViews() {
        super.setupViews()
        
        
        setupView(imageView)
        setupView(stackView)
        stackView.addArrangedSubview(valueLabel)
        stackView.addArrangedSubview(titleLabel)
    }
    
    override func constraintViews() {
        super.constraintViews()
        
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 25),
            imageView.heightAnchor.constraint(equalToConstant: 25),

            stackView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 5.5),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5.5),
        ])
    }
    
    override func configurateAppearance() {
        super.configurateAppearance()
    }
}

//MARK: - StepsSessionView

class StepsView: MainInfoView {
    
    private let barsView = BarsView()
    
    func configurate(with items: [BarView.Data]) {
        barsView.configurate(with: items)
    }
}

extension StepsView {
    override func setupViews() {
        super.setupViews()
        
        setupView(barsView)
    }
    
    override func constraintViews() {
        super.constraintViews()
        
        NSLayoutConstraint.activate([
            barsView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            barsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            barsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            barsView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
        ])
    }
    
    override func configurateAppearance() {
        super.configurateAppearance()
    }
}

