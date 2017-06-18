//
//  SearchViewController.swift
//  MCommerce
//
//  Created by Ambar Septian on 6/19/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit

class SearchViewController: BaseViewController {
    
    @IBOutlet weak var trendingTableView: UITableView! {
        didSet {
            trendingTableView.backgroundColor = Color.cream
        }
    }
    
    @IBOutlet weak var searchTableView: UITableView!
    
    fileprivate lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = true
        searchController.hidesNavigationBarDuringPresentation = false
        
        self.definesPresentationContext = true
        
        return searchController
    }()
    
    fileprivate var childController: ProductListViewController? {
        return self.childViewControllers.first as? ProductListViewController
    }
    
    fileprivate var isSearchActive : Bool {
        return searchController.isActive && searchController.searchBar.text != ""
    }
    
    fileprivate var searchResults = [String]()
    
    fileprivate var trendingResults = [String]()
    
    fileprivate let searchCellID = "SearchCellID"
    
    fileprivate let trendingCellID = "TrendingCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.titleView = searchController.searchBar
        setupChildView()
        
        trendingResults = ["Jaket", "Tas", "Jam Tangan"]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == searchTableView {
            return searchResults.count
        } else {
            return trendingResults.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == searchTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: searchCellID, for: indexPath)
            cell.textLabel?.font = Font.latoRegular.withSize(15)
            cell.textLabel?.textColor = Color.darkGray
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: trendingCellID, for: indexPath)
            cell.textLabel?.font = Font.latoRegular.withSize(15)
            cell.textLabel?.textColor = Color.darkGray
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.text = trendingResults[indexPath.row]
            return cell
        }
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard tableView == trendingTableView else {
            return nil
        }
        
        let view = UIView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: tableView.bounds.width, height: 100)))
        view.backgroundColor = Color.clear
        let label = UILabel(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: tableView.bounds.width, height: 50)))
        label.textColor = Color.orange
        label.font = Font.latoBold.withSize(18)
        label.textAlignment = .center
        label.center = view.center
        label.text = "Trending"
        view.addSubview(label)
        
        return label
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
}

extension SearchViewController {
    func setupChildView(){
        let storyboard = UIStoryboard(name: Constants.storyboard.product, bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: Constants.viewController.product.list) as? ProductListViewController else { return }
        addChildViewController(vc)
        vc.view.frame = view.bounds
        view.addSubview(vc.view)
        vc.didMove(toParentViewController: self)
        vc.view.isHidden = true
    }
}

extension SearchViewController: UISearchBarDelegate {
    
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }

}
