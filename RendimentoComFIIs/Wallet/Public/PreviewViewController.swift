//
//  PreviewViewController.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 19/11/22.
//

import UIKit
import Charts

class PreviewViewController: UIViewController {
    
    @IBOutlet weak var viewHeader: NavigationBarHeaderView!
    @IBOutlet weak var viewData: UIView!
    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var segmentOptions: UISegmentedControl!
    @IBOutlet weak var viewTotalItems: UIView!
    @IBOutlet var collectionLabel: [UILabel]!
    
    var valuesFiis, valuesSegment, listValues: [(String,String)]?
    var dataPublicWallet = (owner: "", rating: "", description: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupLayout()
        
        didTapSegment(segmentOptions)
        
        pieChart.entryLabelColor = .white
        pieChart.entryLabelFont = .systemFont(ofSize: 12, weight: .light)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = UIInterfaceOrientationMask.portrait
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = UIInterfaceOrientationMask.all
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
        viewHeader.setTitleHeader(name: title ?? NSLocalizedString("preview", comment: ""))
        viewHeader.btnReturn.isHidden = true
        
        viewData.backgroundColor = .systemBackground
        viewData.layer.cornerRadius = 16
        
        segmentOptions.customizeAppearance()
        segmentOptions.setTitleList(["FIIs", NSLocalizedString("segment", comment: "")])
        
        collectionLabel.forEach {
            $0.textColor = $0.isEqual(collectionLabel[3]) ? .label : .lightGray
            $0.font = $0.isEqual(collectionLabel[3]) ? UIFont.systemFont(ofSize: 12) : UIFont.boldSystemFont(ofSize: 20)
            $0.textAlignment = .center
            $0.adjustsFontSizeToFitWidth = true
            $0.numberOfLines = $0.isEqual(collectionLabel[2]) ? 8 : 1
            $0.minimumScaleFactor = 0.1
        }
        
        viewTotalItems.backgroundColor = .systemBackground
        viewTotalItems.layer.cornerRadius = 14
        
        collectionLabel.first?.text = "\(NSLocalizedString("owner", comment: "")): \(dataPublicWallet.owner)"
        collectionLabel[1].text = "\(NSLocalizedString("wallet", comment: "")): \(NSLocalizedString(dataPublicWallet.rating, comment: ""))"
        collectionLabel[2].text = dataPublicWallet.description
    }
    
    private func showData() {
        self.setup(pieChartView: pieChart)
        self.setDataCount(listValues?.count ?? 0, range: UInt32(listValues?.count ?? 0))
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
            return PieChartDataEntry(value: (Double(listValues?[i].1.replacingOccurrences(of: ",", with: ".").replacingOccurrences(of: "%", with: "") ?? "0") ?? 0.0) / 5, //Double(arc4random_uniform(range) + range / 5),
                                     label: listValues?[i].0,
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
            listValues = valuesFiis == nil ? Util.calculatePortfolioRatioByFii() : valuesFiis!
            collectionLabel[3].text = "\(listValues?.count ?? 0)   \(listValues?.count ?? 0 > 1 ? "FIIs": "FII")"
        } else {
            listValues = valuesSegment == nil ? Util.calculatePortfolioRatioBySegment() : valuesSegment!
            collectionLabel[3].text = "\(listValues?.count ?? 0)   \(NSLocalizedString("segment", comment: ""))\(listValues?.count ?? 0 > 1 ? "s": "")"
        }
        showData()
    }
    
}
