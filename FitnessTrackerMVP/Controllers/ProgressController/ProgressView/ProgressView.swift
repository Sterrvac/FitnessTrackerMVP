//
//  ProgressView.swift
//  FitnessTrackerMPV
//
//  Created by macbook on 12.01.2023.
//

import UIKit

protocol ProgressViewProtocol {
    var progress: ProgressPresenterProtocol? { get set }
}

class ProgressView: MainViewController, ProgressViewProtocol {
    var progress: ProgressPresenterProtocol?
    
    private let dailyPerformanceView = DailyPerformanceView(with: R.Strings.Progress.dailyPerformance,
                                                           buttonTitle: R.Strings.Progress.lastWeak)
    private let monthlyPerfomanceView = MonthlyPerformanceView(with: R.Strings.Progress.monthlyPerformance,
                                                              buttonTitle: R.Strings.Progress.lastYear)
    
    private let contentView: UIStackView = {
        let view = UIStackView()
        view.isLayoutMarginsRelativeArrangement = true
        view.axis = .vertical
        
        return view
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = true
        
        return scrollView
    }()
}

extension ProgressView {
    override func setupViews() {
        super.setupViews()
        
        contentView.setupView(dailyPerformanceView)
        contentView.setupView(monthlyPerfomanceView)
        
        scrollView.setupView(contentView)
        
        self.view.setupView(scrollView)
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
            
            dailyPerformanceView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            dailyPerformanceView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor,
                                                      constant: 15),
            dailyPerformanceView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            dailyPerformanceView.heightAnchor.constraint(equalTo: dailyPerformanceView.widthAnchor,
                                                         multiplier: 0.68),
            
            monthlyPerfomanceView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            monthlyPerfomanceView.topAnchor.constraint(equalTo: dailyPerformanceView.bottomAnchor,
                                                       constant: 15),
            monthlyPerfomanceView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            monthlyPerfomanceView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            monthlyPerfomanceView.heightAnchor.constraint(equalTo: monthlyPerfomanceView.widthAnchor,
                                                          multiplier: 1.08),
        ])
    }
    
    override func configurateAppearance() {
        super.configurateAppearance()
        
        title = R.Strings.NavBar.progress
        navigationController?.tabBarItem.title = R.Strings.TabBar.title(for: .progress)
        
        addNavBarButton(at: .left, wigh: R.Strings.Progress.navBarLeft)
        addNavBarButton(at: .right, wigh: R.Strings.Progress.navBarRight)
        
        dailyPerformanceView.configurate(with: [.init(value: "1", heightMultiplier: 0.2, title: "MON"),
                                                .init(value: "2", heightMultiplier: 0.4, title: "TUE"),
                                                .init(value: "3", heightMultiplier: 0.6, title: "WED"),
                                                .init(value: "4", heightMultiplier: 0.8, title: "THU"),
                                                .init(value: "5", heightMultiplier: 1, title: "FRI"),
                                                .init(value: "3", heightMultiplier: 0.6, title: "SAT"),
                                                .init(value: "1", heightMultiplier: 0.4, title: "SUN"),])
        
        monthlyPerfomanceView.configuration(with: [.init(value: 45, title: "MAR"),
                                                   .init(value: 55, title: "APR"),
                                                   .init(value: 60, title: "MAY"),
                                                   .init(value: 65, title: "JUN"),
                                                   .init(value: 70, title: "JUL"),
                                                   .init(value: 80, title: "AUG"),
                                                   .init(value: 65, title: "SEP"),
                                                   .init(value: 45, title: "OCT"),
                                                   .init(value: 30, title: "NOV"),
                                                   .init(value: 15, title: "DEC")],
                                            topChartOffset: 10)
    }
}


class DailyPerformanceView: MainInfoView {
    private let barsView = BarsView()
    
    func configurate(with items: [BarView.Data]) {
        barsView.configurate(with: items)
    }
}

extension DailyPerformanceView {
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

class MonthlyPerformanceView: MainInfoView {
    
    private let chartsView = ChartsView()
    
    func configuration(with items: [ChartsView.Data], topChartOffset: Int) {
        chartsView.configurate(with: items, topChartOffset: topChartOffset)
    }
}

extension MonthlyPerformanceView {
    override func setupViews() {
        super.setupViews()
        
        setupView(chartsView)
    }
    
    override func constraintViews() {
        super.constraintViews()
        
        NSLayoutConstraint.activate([
            chartsView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            chartsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            chartsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            chartsView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
        ])
    }
    
    override func configurateAppearance() {
        super.configurateAppearance()
    }
}

class ChartsView: View {
    
    struct Data {
        let value: Int
        let title: String
    }
    
    private let yAxisView = YAxisView()
    private let xAxisView = XAxisView()
    
    private let chartView = ChartView()
    
    func configurate(with data: [ChartsView.Data], topChartOffset: Int = 10) {
        yAxisView.configurate(with: data)
        xAxisView.configurate(with: data)
        chartView.configurate(with: data, topChartOffset: topChartOffset)
    }
}


extension ChartsView {
    override func setupViews() {
        super.setupViews()
        
        setupView(yAxisView)
        setupView(xAxisView)
        setupView(chartView)
    }
    
    override func constraintViews() {
        super.constraintViews()

        NSLayoutConstraint.activate([
            yAxisView.topAnchor.constraint(equalTo: topAnchor),
            yAxisView.leadingAnchor.constraint(equalTo: leadingAnchor),
            yAxisView.bottomAnchor.constraint(equalTo: xAxisView.topAnchor, constant: -12),
            
            xAxisView.leadingAnchor.constraint(equalTo: yAxisView.trailingAnchor, constant: 8),
            xAxisView.bottomAnchor.constraint(equalTo: bottomAnchor),
            xAxisView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 4),
            
            chartView.leadingAnchor.constraint(equalTo: yAxisView.trailingAnchor,
                                               constant: 16),
            chartView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            chartView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            chartView.bottomAnchor.constraint(equalTo: xAxisView.topAnchor, constant: -16),
        ])
    }
    
    override func configurateAppearance() {
        super.configurateAppearance()
        
        backgroundColor = .clear
    }
}

class XAxisView: View {
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.distribution = .equalSpacing
        
        return view
    }()
    
    func configurate(with data: [ChartsView.Data]) {
        stackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        
        data.forEach {
            let label = UILabel()
            label.font = R.Fonts.helvelicaRegular(with: 9)
            label.textColor = R.Colors.inactive
            label.textAlignment = .center
            label.text = $0.title.uppercased()
            
            stackView.addArrangedSubview(label)
        }
    }
    
}


extension XAxisView {
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
        
        backgroundColor = .clear
    }
}

class YAxisView: View {
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .equalSpacing
        
        return view
    }()
    
    func configurate(with data: [ChartsView.Data]) {
        stackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        
        (0...9).reversed().forEach {
            let label = UILabel()
            label.font = R.Fonts.helvelicaRegular(with: 9)
            label.textColor = R.Colors.inactive
            label.textAlignment = .right
            label.text = "\($0 * 10)" // TODO: -Remake Interval
            
            stackView.addArrangedSubview(label)
        }
    }
    
}


extension YAxisView {
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
        
        backgroundColor = .clear
    }
}

class ChartView: View {
    
    private let xAxisSeporator: UIView = {
        let view = UIView()
        view.backgroundColor = R.Colors.separator
        
        return view
    }()
    
    private let yAxisSeporator: UIView = {
        let view = UIView()
        view.backgroundColor = R.Colors.separator
        
        return view
    }()
    
    func configurate(with data: [ChartsView.Data], topChartOffset: Int) {
        
        layoutIfNeeded()
        drawDashLines()
        drawChrat(with: data, topChartOffset: topChartOffset)
    }
}


extension ChartView {
    override func setupViews() {
        super.setupViews()
        
        setupView(xAxisSeporator)
        setupView(yAxisSeporator)
    }
    
    override func constraintViews() {
        super.constraintViews()

        NSLayoutConstraint.activate([
            xAxisSeporator.leadingAnchor.constraint(equalTo: leadingAnchor),
            xAxisSeporator.trailingAnchor.constraint(equalTo: trailingAnchor),
            xAxisSeporator.bottomAnchor.constraint(equalTo: bottomAnchor),
            xAxisSeporator.heightAnchor.constraint(equalToConstant: 1),
            
            yAxisSeporator.topAnchor.constraint(equalTo: topAnchor),
            yAxisSeporator.leadingAnchor.constraint(equalTo: leadingAnchor),
            yAxisSeporator.bottomAnchor.constraint(equalTo: bottomAnchor),
            yAxisSeporator.widthAnchor.constraint(equalToConstant: 1),
        ])
    }
    
    override func configurateAppearance() {
        super.configurateAppearance()
        
        backgroundColor = .clear
    }
}

private extension ChartView {
    func drawDashLines(with counts: Int = 9) {
        (0..<counts).map { CGFloat($0) }.forEach {
            drawDashLine(at: bounds.height / CGFloat(counts) * $0)
        }
    }
    
    func drawDashLine(at yPosition: CGFloat) {
        let startPoint = CGPoint(x: 0, y: yPosition)
        let endPoint = CGPoint(x: bounds.width, y: yPosition)
        
        let duchPath = CGMutablePath()
        duchPath.addLines(between: [startPoint, endPoint])
        
        let duchLayer = CAShapeLayer()
        duchLayer.path = duchPath
        duchLayer.strokeColor = R.Colors.separator.cgColor
        duchLayer.lineWidth = 1
        duchLayer.lineDashPattern = [6, 3]
        
        layer.addSublayer(duchLayer)
    }
    
    func drawChrat(with data: [ChartsView.Data], topChartOffset: Int) {
        guard let maxValue = data.sorted(by: { $0.value > $1.value }).first?.value else { return }
        let valuePoints = data.enumerated().map {CGPoint(x: CGFloat($0), y: CGFloat($1.value))}
        let chartHeight = bounds.height / CGFloat(maxValue + topChartOffset)
        
        let points = valuePoints.map {
            let x = bounds.width / CGFloat(valuePoints.count - 1) * $0.x
            let y = bounds.height - $0.y * chartHeight
            return CGPoint(x: x, y: y)
        }
        
        let chartPath = UIBezierPath()
        chartPath.move(to: points[0])
        
        points.forEach {
            chartPath.addLine(to: $0)
            drawChartDot(at: $0)
        }
        
        let chartLayer = CAShapeLayer()
        chartLayer.path = chartPath.cgPath
        chartLayer.fillColor = UIColor.clear.cgColor
        chartLayer.strokeColor = R.Colors.active.cgColor
        chartLayer.lineWidth = 3
        chartLayer.strokeEnd = 1
        chartLayer.lineJoin = .round
        
        layer.addSublayer(chartLayer)
    }
    
    func drawChartDot(at point: CGPoint) {
        let dotPath = UIBezierPath()
        dotPath.move(to: point)
        dotPath.addLine(to: point)
        
        let dotLayer = CAShapeLayer()
        dotLayer.path = dotPath.cgPath
        dotLayer.strokeColor = R.Colors.active.cgColor
        dotLayer.lineCap = .round
        dotLayer.lineWidth = 10
        
        layer.addSublayer(dotLayer)
    }
}


