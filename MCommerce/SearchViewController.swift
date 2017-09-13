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
        searchController.searchBar.addSubview(self.activityIndicator)
        self.definesPresentationContext = true
        
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
        view.title = self.defaultEmptyViewTitle
       
        return view
    }()

    fileprivate var defaultEmptyViewTitle:String {
        return "emptySearch".localize
    }
    
    fileprivate var searchNotFoundTitle:String {
        guard let keyword = controller.keyword else { return "" }
        return String(format:"emptySearchResults".localize, keyword)
    }

    
    fileprivate var searchTimer: Timer?
    
    fileprivate var keyboardHeight:CGFloat = 0
    
    fileprivate lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        activityIndicator.color = Color.green
        activityIndicator.hidesWhenStopped = true
        
        return activityIndicator
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubviews()
        
        loadSearchList()
        navigationItem.titleView = searchController.searchBar
        
        adjustActivityIndicator()
        
        NotificationCenter.default.addObserver(self, selector:#selector(self.keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.isTranslucent = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.extendedLayoutIncludesOpaqueBars = false
        searchTableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        automaticallyAdjustsScrollViewInsets = false
        navigationController?.navigationBar.isTranslucent = true
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
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
    
    
    func beginSearchWithTimer(timer: Timer) {
        guard let userInfo = timer.userInfo as? Dictionary<String, AnyObject> else { return }
        guard let keyword = userInfo["keyword"] as? String else { return }
        
        activityIndicator.startAnimating()
        controller.keyword = keyword
        
    }
    
    func adjustActivityIndicator(){
        let bounds = searchController.searchBar.bounds
        let origin = CGPoint(x:bounds.width * 0.6 - self.activityIndicator.bounds.width , y: bounds.origin.y + self.activityIndicator.bounds.height / 2)
        self.activityIndicator.frame.origin = origin
        
    }
    
    
    func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
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
        let cell = SearchTableViewCell.configureCell(tableView: tableView, indexPath: indexPath, object: product) as! SearchTableViewCell
        cell.currentVC = searchController
        return cell
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
            emptyView.toggleHide(willHide: false, replaceTitle: defaultEmptyViewTitle)
            return }
        guard keyword.characters.count > 2 else {
            emptyView.toggleHide(willHide: false, replaceTitle: defaultEmptyViewTitle)
            return
        }
        
        if let timer = searchTimer {
            if timer.isValid {
                searchTimer?.invalidate()
            }
        }
        
        let userInfo = ["keyword": keyword]
        searchTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector:#selector(beginSearchWithTimer(timer:)), userInfo: userInfo, repeats: false)
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        controller.keyword = nil
        emptyView.toggleHide(willHide: false, replaceTitle: defaultEmptyViewTitle)
    }
}

extension SearchViewController: SearchProductDelegate {
    func refreshFilterProduct() {
        searchTableView.reloadData()
        searchTableView.contentSize.height += keyboardHeight + 20
        
        activityIndicator.stopAnimating()
        let willHidden = controller.products.count == 0 ? false : true
        emptyView.toggleHide(willHide: willHidden, replaceTitle: searchNotFoundTitle)
        
    }

}
