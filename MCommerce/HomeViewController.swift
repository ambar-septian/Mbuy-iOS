//
//  HomeViewController.swift
//  MCommerce
//
//  Created by Ambar Septian on 5/22/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit
import Anchorage

class HomeViewController: BaseViewController {
    
    let controller = CategoryController()
    
    var categories = [Category]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            let cell = CategoryHomeTableViewCell.self
            tableView.register(cell, forCellReuseIdentifier: cell.identifier)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        
        loadCategories()

    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "home".localize
        tableView.reloadData()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.segueID.product.list {
            guard let vc = segue.destination as? ProductListViewController else { return }
            guard let index = sender as? Int else { return }
            vc.passedCategory = self.categories[index]
        }
    }
}

extension HomeViewController {
    func loadCategories(){
        showProgressHUD()
        DispatchQueue.global().async {
            self.controller.loadCategories { (categories) in
                self.hideProgressHUD()
                CurrentCategories.removeAll()
                CurrentCategories = categories
                self.categories = categories
            }
        }
       
    }
}


extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let category = categories[indexPath.row]
        return CategoryHomeTableViewCell.configureCell(tableView: tableView, indexPath: indexPath, object: category)
       
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: Constants.segueID.product.list, sender: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}
