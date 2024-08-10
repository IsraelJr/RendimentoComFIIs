//
//  MonthlyClosingViewController.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 31/05/22.
//

import UIKit
import Charts
import TinyConstraints

class MonthlyClosingViewController: UIViewController {
    
    @IBOutlet weak var viewHeader: NavigationBarHeaderView!
    @IBOutlet weak var collectionYear: UICollectionView!
    @IBOutlet weak var chartView: UIView!
    @IBOutlet weak var segmentOptions: UISegmentedControl!
    
    enum GraphicDataType {
        case dividend
        case patrimony
        case total
    }
    
    let months = [NSLocalizedString(Month.january.description().0, comment: "").prefix(3).description
                  ,NSLocalizedString(Month.february.description().0, comment: "").prefix(3).description
                  ,NSLocalizedString(Month.march.description().0, comment: "").prefix(3).description
                  ,NSLocalizedString(Month.april.description().0, comment: "").prefix(3).description
                  ,NSLocalizedString(Month.may.description().0, comment: "").prefix(3).description
                  ,NSLocalizedString(Month.june.description().0, comment: "").prefix(3).description
                  ,NSLocalizedString(Month.july.description().0, comment: "").prefix(3).description
                  ,NSLocalizedString(Month.august.description().0, comment: "").prefix(3).description
                  ,NSLocalizedString(Month.september.description().0, comment: "").prefix(3).description
                  ,NSLocalizedString(Month.october.description().0, comment: "").prefix(3).description
                  ,NSLocalizedString(Month.november.description().0, comment: "").prefix(3).description
                  ,NSLocalizedString(Month.december.description().0, comment: "").prefix(3).description
    ]
    
    lazy var lineChartView: LineChartView = {
        let chartView = LineChartView()
        chartView.backgroundColor = UIColor(named: "Border")
        
        chartView.rightAxis.enabled = false
        
        let yAxis = chartView.leftAxis
        yAxis.labelFont = .boldSystemFont(ofSize: 12)
        //        yAxis.setLabelCount(12, force: false)
        yAxis.labelTextColor = .white
        yAxis.axisLineColor = .white
        yAxis.labelPosition = .outsideChart
        
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.labelFont = .boldSystemFont(ofSize: 12)
        //        chartView.xAxis.setLabelCount(12, force: false)
        chartView.xAxis.labelTextColor = .white
        chartView.xAxis.axisLineColor = .systemBlue
        
        chartView.animate(xAxisDuration: 1.5)
        
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: months)
        chartView.xAxis.setLabelCount(months.count, force: true)
        
        return chartView
    }()
    
    var yValues = [ChartDataEntry]()
    var dividendYears = WalletViewController.wallet?.annualEarnings
    var tempList: [String:Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = UIInterfaceOrientationMask.all
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = UIInterfaceOrientationMask.portrait
        }
    }
    
    private func setupLayout() {
        viewHeader.setTitleHeader(name: NSLocalizedString("line_chart", comment: ""))
        viewHeader.delegate = self
        
        collectionYear.delegate = self
        collectionYear.dataSource = self
        
        chartView.backgroundColor = view.backgroundColor
        chartView.addSubview(lineChartView)
        lineChartView.delegate = self
        lineChartView.centerInSuperview()
        lineChartView.width(to: chartView)
        lineChartView.height(to: chartView)
        lineChartView.legend.enabled = false
        
        setData(year: Util.currentYear, typeData: .dividend)
//        setupLineChart()
        
        segmentOptions.customizeAppearance()
//        segmentOptions.setTitleList([NSLocalizedString("dividend", comment: ""), NSLocalizedString("patrimony", comment: "")])
        segmentOptions.setTitleList(["Fechamento", NSLocalizedString("dividend", comment: "")])
                
    }
    
    private func setupLineChart() {
        let set = LineChartDataSet(entries: yValues, label: "")
        set.drawCirclesEnabled = false
        //set.mode = .cubicBezier
        set.lineWidth = 3
        set.setColor(.white)
        set.fill = ColorFill(color: .systemGray6)
        //set.fillAlpha = 0.8
        set.drawFilledEnabled = true
        set.drawHorizontalHighlightIndicatorEnabled = false
        set.highlightColor = .systemRed
        
        let data = LineChartData(dataSet: set)
        //data.setDrawValues(false)
        lineChartView.data = data
    }
    
    private func setData(year: String, typeData: GraphicDataType) {
        yValues.removeAll()
        var listValues = [Any]()
        switch typeData {
        case .dividend:
            dividendYears == nil ? (dividendYears = ["2023":["January":0]]) : nil
            listValues = Array(arrayLiteral: dividendYears!.first(where: {$0.key.elementsEqual(year)})?.value as Any)
            tempList = dividendYears
            
        case .patrimony:
            listValues = Array(arrayLiteral: ReportModel.patrimony?.patrimony.first(where: {$0.key.elementsEqual(year)})?.value as Any)
            tempList = ReportModel.patrimony?.patrimony
            
        case .total:
            break
        }
        for i in 1...12 {
            let value = ((listValues[0] as? [String:Any])?.first(where: {$0.key.elementsEqual(NSLocalizedString("\(i)", comment: ""))})?.value ?? 0.0) as? Double ?? 0.0
            yValues.append(ChartDataEntry(x: Double(i-1), y: (value*100.0)/100.0))
            quoteList.first(where: {$0.code.elementsEqual("TGAR11")})?.closing.forEach { c in
                yValues.append(ChartDataEntry(x: Double(i-1), y: c.price.convertCurrencyToDouble()))
                }
            
        }
        setupLineChart()
    }
    
    private func activateGraph(_ data: GraphicDataType) {
        setData(year: Util.currentYear, typeData: data)
        tempList?.keys.contains(Util.currentYear) ?? true ? nil : setData(year: ((Int(Util.currentYear) ?? 0) - 1).description, typeData: data)
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {

            switch swipeGesture.direction {
            case .right:
                self.dismissWith()
            default:
                break
            }
        }
    }
    
    @IBAction func didTapOptions(_ sender: UISegmentedControl) {
        sender.selectedSegmentIndex == 0 ? activateGraph(.dividend) : activateGraph(.patrimony)
        collectionYear.reloadData()
    }
    
}


extension MonthlyClosingViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry.y)
    }
    
}


extension MonthlyClosingViewController: NavigationBarHeaderDelegate {
    func didTapButtonBack(_ sender: UIButton) {
        dismissWith()
    }
}

extension MonthlyClosingViewController: AxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return months[Int(value) % months.count]
    }
}


extension MonthlyClosingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tempList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! YearCollectionViewCell
        cell.setData(from: (Array(tempList!.keys.sorted(by: {$0 > $1}))[indexPath.row]) )
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        indexPath.row == 0 ? ((cell as! YearCollectionViewCell).viewBackground.backgroundColor = viewHeader.viewBackground.backgroundColor) : ((cell as! YearCollectionViewCell).viewBackground.backgroundColor = .lightGray)
        collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: [])
    }
    
}


extension MonthlyClosingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 250 / 2, height: 250 / 4)
    }
    
}


extension MonthlyClosingViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! YearCollectionViewCell
        setData(year: cell.title.text ?? "", typeData: segmentOptions.selectedSegmentIndex == 0 ? .dividend : .patrimony)
        cell.viewBackground.backgroundColor = viewHeader.viewBackground.backgroundColor
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! YearCollectionViewCell
        cell.viewBackground.backgroundColor = .lightGray
    }
}

