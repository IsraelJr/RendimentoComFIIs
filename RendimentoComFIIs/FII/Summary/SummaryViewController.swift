//
//  ViewController.swift
//  RendimentoComFIIs
//
//  Created by Israel Alves on 26/03/22.
//

import UIKit

protocol SummaryDisplayLogic {
    func showSomething(_ object: SummaryModel.Fetch.Summary)
}


class SummaryViewController: UIViewController, SummaryDisplayLogic {
    
    @IBOutlet weak var viewHeader: NavigationBarHeaderView!
    @IBOutlet weak var tableSummary: UITableView!
    
    struct Section {
        var mainCellTitle: String
        var expandableCellOptions: [String]
        var isExpandableCellsHidden: Bool
    }
    
    var sections: [Section] = [
        Section(mainCellTitle: "Objetivo", expandableCellOptions: ["1", "2", "3"], isExpandableCellsHidden: true),
        Section(mainCellTitle: "Público Alvo", expandableCellOptions: ["4", "5", "6"], isExpandableCellsHidden: true),
        Section(mainCellTitle: "Taxa de Administração e Gestão", expandableCellOptions: ["7", "8", "9"], isExpandableCellsHidden: true),
    ]
    
    var interactor: SummaryBusinessLogic?
    var router: (NSObjectProtocol & SummaryRoutingLogic & SummaryDataPassing)?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let interactor = SummaryInteractor()
        let presenter = SummaryPresenter()
        let router = SummaryRouter()
        
        self.interactor = interactor
        self.router = router
        interactor.presenter = presenter
        presenter.viewController = self
        router.viewController = self
        router.dataStore = interactor
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //        if let scene = segue.identifier {
        //            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
        //            if let router = router, router.responds(to: selector) {
        //                router.perform(selector, with: segue)
        //            }
        //        }
        //        router?.routeTosegueHomeWithSegue(segue: segue)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupLayout()
    }
    
    private func setupLayout() {
        
        viewHeader.setTitleHeader(name: NSLocalizedString("title_summary_fii", comment: ""))
        viewHeader.btnReturn.isHidden = true
        
        tableSummary.delegate = self
        tableSummary.dataSource = self
        
        tableSummary.register(UINib(nibName: SummaryCell.cellIdentifier, bundle: nil), forCellReuseIdentifier: SummaryCell.cellIdentifier)
        tableSummary.register(UINib(nibName: SummaryMainCell.cellIdentifier, bundle: nil), forCellReuseIdentifier: SummaryMainCell.cellIdentifier)
    }
    
    func showSomething(_ object: SummaryModel.Fetch.Summary) {
        
    }
    
}

extension SummaryViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        if !section.isExpandableCellsHidden {
            return section.expandableCellOptions.count + 1
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // section main cell title
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: SummaryMainCell.cellIdentifier, for: indexPath) as! SummaryMainCell
            cell.label.text = sections[indexPath.section].mainCellTitle
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: SummaryCell.cellIdentifier, for: indexPath) as! SummaryCell
            cell.label.text = sections[indexPath.section].expandableCellOptions[indexPath.row - 1]
            return cell
        }
    }
    
    
}


extension SummaryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for i in 0..<sections.count {
            if i == indexPath.row {
                sections[indexPath.section].isExpandableCellsHidden = !sections[indexPath.section].isExpandableCellsHidden
            } else {
//                sections[indexPath.row].isExpandableCellsHidden = true
                sections[i].isExpandableCellsHidden = true
            }
        }
        tableView.reloadData()
    }
    
}


