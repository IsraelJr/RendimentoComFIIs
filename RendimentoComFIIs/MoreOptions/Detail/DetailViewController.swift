//
//  DetailViewController.swift
//  RendimentoComFII
//
//  Created by Israel Alves on 27/04/22.
//

import UIKit
import FirebaseFirestore

protocol DetailDisplayLogic {
    func setTitleToItem(_ title: String)
    func showAboutFii(_ list: [(title: String, description: String?)])
    func showLibrary(_ list: [String])
    func showGlossary(_ list: [DetailModel.FetchGlossary.Glossary])
    func showBooks(_ list: [DetailModel.FetchBooks.Books])
    func showCourses(_ list: [DetailModel.FetchCourses.Courses])
    func showBrokers(_ list: [DetailModel.FetchBrokers.Brokers])
    func showTax(_ list: [DetailModel.FetchTax.Tax])
}


class DetailViewController: UIViewController, DetailDisplayLogic {
    
    @IBOutlet weak var viewHeader: NavigationBarHeaderView!
    @IBOutlet weak var tableDetail: UITableView!
    
    var titleTable = ""
    var listAboutFii: [(title: String, description: String?)]?
    var listLibrary = [String]()
    var listGlossary = [DetailModel.FetchGlossary.Glossary]()
    var listBooks = [DetailModel.FetchBooks.Books]()
    var listCourses = [DetailModel.FetchCourses.Courses]()
    var listBrokers = [DetailModel.FetchBrokers.Brokers]()
    var listTax = [DetailModel.FetchTax.Tax]()
    
    var interactor: DetailBusinessLogic?
    var router: (NSObjectProtocol & DetailRoutingLogic & DetailDataPassing)?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let interactor = DetailInteractor()
        let presenter = DetailPresenter()
        let router = DetailRouter()
        
        self.interactor = interactor
        self.router = router
        interactor.presenter = presenter
        presenter.viewController = self
        router.viewController = self
        router.dataStore = interactor
    }
    
    // MARK: Routing
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.getSegueToItem()
        setupLayout()
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
            case .right:
                didTapButtonBack(viewHeader.btnReturn)
            default:
                break
            }
        }
    }
    
    private func setupLayout() {
        viewHeader.delegate = self
        
        tableDetail.delegate = self
        tableDetail.dataSource = self
    }
    
    func setTitleToItem(_ title: String) {
        self.title = title
        viewHeader.setTitleHeader(name: self.title ?? "")
    }
    
    func showAboutFii(_ list: [(title: String, description: String?)]) {
        listAboutFii = list
        titleTable = listAboutFii?.removeFirst().title ?? ""
        DispatchQueue.main.async {
            self.tableDetail.reloadData()
        }
    }
    
    func showLibrary(_ list: [String]) {
        listLibrary = list
        DispatchQueue.main.async {
            self.tableDetail.reloadData()
        }
    }
    
    func showGlossary(_ list: [DetailModel.FetchGlossary.Glossary]) {
        listGlossary = list
        titleTable = ItemsLibrary.glossary.description()
        DispatchQueue.main.async {
            self.tableDetail.reloadData()
        }
    }
    
    func showBooks(_ list: [DetailModel.FetchBooks.Books]) {
        listBooks = list
        titleTable = ItemsLibrary.books.description()
        DispatchQueue.main.async {
            self.tableDetail.reloadData()
        }
    }
    
    func showCourses(_ list: [DetailModel.FetchCourses.Courses]) {
        listCourses = list
        titleTable = ItemsLibrary.courses.description()
        DispatchQueue.main.async {
            self.tableDetail.reloadData()
        }
    }
    
    func showBrokers(_ list: [DetailModel.FetchBrokers.Brokers]) {
        listBrokers = list
        titleTable = ItemsLibrary.brokers.description()
        DispatchQueue.main.async {
            self.tableDetail.reloadData()
        }
    }
    func showTax(_ list: [DetailModel.FetchTax.Tax]) {
        listTax = list
        titleTable = ItemsLibrary.tax.description()
        DispatchQueue.main.async {
            self.tableDetail.reloadData()
        }
    }
}


extension DetailViewController: NavigationBarHeaderDelegate {
    func didTapButtonBack(_ sender: UIButton) {
        if listLibrary.isEmpty {
            dismissWith()
        } else {
            if !listCourses.isEmpty || !listGlossary.isEmpty || !listBooks.isEmpty || !listBrokers.isEmpty || !listTax.isEmpty {
                listCourses.removeAll()
                listGlossary.removeAll()
                listBooks.removeAll()
                listBrokers.removeAll()
                listTax.removeAll()
                titleTable.removeAll()
                self.tableDetail.reloadData()
            } else {
                dismissWith()
            }
        }
    }
}


extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if titleTable.isEmpty {
            return listLibrary.isEmpty ? (listGlossary.count + listBooks.count + listCourses.count + listBrokers.count + listTax.count) : listLibrary.count
        } else {
            return listAboutFii?.count ?? 0 + listGlossary.count + listBooks.count + listCourses.count + listBrokers.count + listTax.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellDetail") as! DetailTableViewCell
        
        if listAboutFii?.count ?? 0 > 0 {
            cell.setData(from: listAboutFii?[indexPath.row].title ?? "")
            
        } else if !listGlossary.isEmpty || !listBooks.isEmpty || !listCourses.isEmpty || !listBrokers.isEmpty || !listTax.isEmpty {
            switch titleTable {
            case ItemsLibrary.glossary.description():
                cell.setData(from: (listGlossary[indexPath.row].name ?? ""), listGlossary[indexPath.row].new, listGlossary[indexPath.row].updated)
                
            case ItemsLibrary.books.description():
                cell.setData(from: (listBooks[indexPath.row].title ?? ""), listBooks[indexPath.row].new, listBooks[indexPath.row].updated)
                
            case ItemsLibrary.courses.description():
                cell.setData(from: (listCourses[indexPath.row].title ?? ""), listCourses[indexPath.row].new, listCourses[indexPath.row].updated)
                
            case ItemsLibrary.brokers.description():
                cell.setData(from: (listBrokers[indexPath.row].title ?? ""), listBrokers[indexPath.row].new, listBrokers[indexPath.row].updated)
                
            case ItemsLibrary.tax.description():
                cell.setData(from: (listTax[indexPath.row].name ?? ""), listTax[indexPath.row].new, listTax[indexPath.row].updated)
                
            default:
                break
            }
        } else {
            cell.animateTransition(indexPath.row)
            cell.setData(from: listLibrary[indexPath.row])
        }
        
        cell.contentView.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return titleTable.isEmpty ? 0 : 50
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "\(titleTable)"
        label.textColor = .gray
        label.backgroundColor = tableView.backgroundColor
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.1
        label.translatesAutoresizingMaskIntoConstraints = true
        tableView.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: tableView.topAnchor, constant: 0),
            label.leadingAnchor.constraint(equalTo: tableView.leadingAnchor, constant: 0),
            label.trailingAnchor.constraint(equalTo: tableView.trailingAnchor, constant: 0),
            label.heightAnchor.constraint(equalToConstant: 40)
        ])
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
}


extension DetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.contentView.backgroundColor = UIColor(named: "Border")
        let cellTitle = (tableView.cellForRow(at: indexPath) as! DetailTableViewCell).title.text ?? ""
        switch cellTitle {
        case ItemsLibrary.glossary.description():
            interactor?.getGlossary()
            
        case ItemsLibrary.books.description():
            interactor?.getBooks()
            
        case ItemsLibrary.courses.description():
            interactor?.getCourses()
            
        case ItemsLibrary.brokers.description():
            interactor?.getBrokers()
            
        case ItemsLibrary.tax.description():
            interactor?.getTax()
            
        default:
            let vc = storyboard?.instantiateViewController(withIdentifier: "detailDescription") as! DetailDescriptionViewController
            vc.title = cellTitle
            if listAboutFii?.count ?? 0 > 0 {
                vc.desc = listAboutFii?.first(where: {$0.title.elementsEqual(cellTitle)})?.description ?? ""
                present(vc, animated: true, completion: nil)
            } else if listGlossary.count > 0 {
                var source = ""
                listGlossary[indexPath.row].source?.forEach({ source += "\($0)\n\n"})
                vc.desc = "\(listGlossary.first(where: {$0.name.elementsEqual(cellTitle)})?.desc ?? "")\(NSLocalizedString("source", comment: "")):\n\(source)"
                present(vc, animated: true, completion: nil)
            } else if listBooks.count > 0 {
                let vc = storyboard?.instantiateViewController(withIdentifier: "detailDescriptionBooks") as! DetailDescriptionBooksViewController
                vc.book = listBooks[indexPath.row]
                segueTo(destination: vc)
            } else if listCourses.count > 0 {
                let vc = storyboard?.instantiateViewController(withIdentifier: "detailDescriptionCourses") as! DetailDescriptionCoursesViewController
                vc.course = listCourses[indexPath.row]
                segueTo(destination: vc)
            } else if listBrokers.count > 0 {
                let vc = storyboard?.instantiateViewController(withIdentifier: "detailDescriptionBrokers") as! DetailDescriptionBrokersViewController
                vc.broker = listBrokers[indexPath.row]
                segueTo(destination: vc)
            } else if listTax.count > 0 {
                var source = ""
                listTax[indexPath.row].source?.forEach({ source += "\($0)\n\n"})
                vc.desc = "\(listTax.first(where: {$0.name.elementsEqual(cellTitle)})?.desc ?? "")\(NSLocalizedString("source", comment: "")):\n\(source)"
                present(vc, animated: true, completion: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.contentView.backgroundColor = .clear
    }
}
