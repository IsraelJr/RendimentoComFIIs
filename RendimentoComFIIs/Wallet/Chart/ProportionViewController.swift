//
//  ProportionViewController.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 19/11/22.
//

import UIKit
import Charts

class ProportionViewController: UIViewController {
    
    @IBOutlet weak var viewHeader: NavigationBarHeaderView!
    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var segmentOptions: UISegmentedControl!
    @IBOutlet weak var viewTotalItems: UIView!
    @IBOutlet weak var labelTotalItems: UILabel!
    
    
    var listValues = [(String,String)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupLayout()
        
        didTapSegment(segmentOptions)
        
        pieChart.entryLabelColor = .white
        pieChart.entryLabelFont = .systemFont(ofSize: 12, weight: .light)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
    }
    
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    private func setupLayout() {
        viewHeader.setTitleHeader(name: NSLocalizedString("pie_chart", comment: ""))
        viewHeader.delegate = self
        
        segmentOptions.customizeAppearance()
        segmentOptions.setTitleList(["FIIs", NSLocalizedString("Segment", comment: "")])
        
        viewTotalItems.backgroundColor = .systemBackground
        viewTotalItems.layer.cornerRadius = 14
        
        labelTotalItems.font = UIFont.systemFont(ofSize: 12)
        labelTotalItems.textAlignment = .center
        
    }
    
    private func showData() {
        self.setup(pieChartView: pieChart)
        self.setDataCount(listValues.count, range: UInt32(listValues.count))
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
    
    func setup(pieChartView chartView: PieChartView) {
        chartView.usePercentValuesEnabled = true
        chartView.drawSlicesUnderHoleEnabled = false
        chartView.holeRadiusPercent = 0.58
        chartView.transparentCircleRadiusPercent = 0.61
        chartView.chartDescription.enabled = false
        chartView.setExtraOffsets(left: 5, top: 10, right: 5, bottom: 5)
        
        chartView.drawCenterTextEnabled = true
        chartView.holeColor = .clear
        
        let paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.alignment = .center
        
        let centerText = NSMutableAttributedString(string: NSLocalizedString("text_chart", comment: ""))
        centerText.setAttributes([.font : UIFont(name: "HelveticaNeue-Light", size: 12)!,
                                  .paragraphStyle : paragraphStyle,
                                  .foregroundColor : UIColor.gray],
                                 range: NSRange(location: 0, length: centerText.length))
//        centerText.addAttributes([.font : UIFont(name: "HelveticaNeue-Light", size: 11)!,
//                                  .foregroundColor : UIColor.gray], range: NSRange(location: 10, length: centerText.length - 10))
//        centerText.addAttributes([.font : UIFont(name: "HelveticaNeue-Light", size: 11)!,
//                                  .foregroundColor : UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)], range: NSRange(location: centerText.length - 19, length: 19))
        chartView.centerAttributedText = centerText;
        
        chartView.drawHoleEnabled = true
        chartView.rotationAngle = 0
        chartView.rotationEnabled = true
        chartView.highlightPerTapEnabled = true
        
        let l = chartView.legend
        l.horizontalAlignment = .center
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = false
        l.xEntrySpace = 7
        l.yEntrySpace = 7
        l.yOffset = 0
        //        chartView.legend = l
    }
    
    func setDataCount(_ count: Int, range: UInt32) {
        var entries = [PieChartDataEntry]()
        entries = (0..<count).map { (i) -> PieChartDataEntry in
            // IMPORTANT: In a PieChart, no values (Entry) should have the same xIndex (even if from different DataSets), since no values can be drawn above each other.
            return PieChartDataEntry(value: Double(listValues[i].1.replacingOccurrences(of: ",", with: ".").replacingOccurrences(of: "%", with: ""))! / 5, //Double(arc4random_uniform(range) + range / 5),
                                     label: listValues[i].0,
                                     icon: UIImage(named: "pie_chart"))
        }
        
        if entries.isEmpty {
            entries = [PieChartDataEntry.init(value: 100.0, label: "FII", icon: UIImage(named: "pie_chart"))]
        }
        
        let set = PieChartDataSet(entries: entries, label: "") //"Election Results")
        set.drawIconsEnabled = false
        set.sliceSpace = 4
        set.valueLineVariableLength = false
        
        
        set.colors = ChartColorTemplates.vordiplom()
        + ChartColorTemplates.joyful()
        + ChartColorTemplates.colorful()
        + ChartColorTemplates.liberty()
        + ChartColorTemplates.pastel()
        + [UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)]
        
        let data = PieChartData(dataSet: set)
        
        let pFormatter = NumberFormatter().percentWith2Decimal()
        
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        
        data.setValueFont(NSUIFont(name: "HelveticaNeue-Light", size: 11)!)
        data.setValueTextColor(NSUIColor(ciColor: .black))
        
        pieChart.data = data
        pieChart.highlightValues(nil)
    }
    
    @IBAction func didTapSegment(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            listValues = Util.calculatePortfolioRatioByFii()
            labelTotalItems.text = "\(listValues.count)   \(listValues.count > 1 ? "FIIs": "FII")"
        } else {
            listValues = Util.calculatePortfolioRatioBySegment()
            labelTotalItems.text = "\(listValues.count)   \(NSLocalizedString("segment", comment: ""))\(listValues.count > 1 ? "s": "")"
        }
        showData()
    }
    
}


extension ProportionViewController: NavigationBarHeaderDelegate {
    func didTapButtonBack(_ sender: UIButton) {
        dismissWith()
    }
}
