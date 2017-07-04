//
//  SearchViewController.swift
//  MCommerce
//
//  Created by Ambar Septian on 6/19/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit
import Iconic
import Anchorage

class SearchViewController: BaseViewController {

    @IBOutlet weak var searchTableView: UITableView! {
        didSet {
            let cell = SearchTableViewCell.self
            searchTableView.register(cell.nib, forCellReuseIdentifier: cell.identifier)
        }
    }
    
    fileprivate lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.searchBarStyle = .prominent
//        self.definesPresentationContext = true
        
        return searchController
    }()
    
    
    fileprivate var isSearchActive : Bool {
        return searchController.isActive && searchController.searchBar.text != ""
    }
    
    fileprivate var searchResults:[Product] {
        return controller.products
    }
    
    fileprivate lazy var controller : SearchController = {
        let controller = SearchController()
        controller.delegate = self
    
        return controller
    }()
    
    fileprivate lazy var emptyView: EmptyDataView =  {
        let view = EmptyDataView(frame: self.view.bounds)
        view.image = #imageLiteral(resourceName: "search")
        view.title = "emptySearch".localize
       
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubviews()
        
        loadSearchList()
        navigationItem.titleView = searchController.searchBar
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         self.extendedLayoutIncludesOpaqueBars = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        automaticallyAdjustsScrollViewInsets = false
    }
}

extension SearchViewController {
    func loadSearchList(){
        showProgressHUD()
        DispatchQueue.global().async {
            self.controller.getSearchList(completion: { (completed) in
                DispatchQueue.main.async {
                    self.hideProgressHUD()
                }
            })
        }
    }
}

extension SearchViewController: BaseViewProtocol {
    func setupSubviews() {
         view.addSubview(emptyView)
    }
    
    func setupConstraints() {
        emptyView.edgeAnchors == self.edgeAnchors
    }
}


extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let product = searchResults[indexPath.row]
        return SearchTableViewCell.configureCell(tableView: tableView, indexPath: indexPath, object: product)
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let product = searchResults[indexPath.row]
        
        let storyboard = UIStoryboard(name: Constants.storyboard.product, bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: Constants.viewController.product.detail) as? ProductDetailViewController else { return }
        vc.passedProduct = product
        pushNavigation(targetVC: vc)
    }
}

extension SearchViewController: UISearchBarDelegate {
    
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let keyword = searchController.searchBar.text else {
            emptyView.toggleHide(willHide: false)
            return }
        guard keyword.characters.count > 2 else {
            emptyView.toggleHide(willHide: false)
            return
        }
        controller.keyword = keyword
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        controller.keyword = nil
        emptyView.toggleHide(willHide: false)
    }
}

extension SearchViewController: SearchProductDelegate {
    func refreshFilterProduct() {
        searchTableView.reloadData()
        let willHidden = controller.products.count == 0 ? false : true
        emptyView.toggleHide(willHide: willHidden)
        
    }

}
