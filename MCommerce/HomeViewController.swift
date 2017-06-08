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
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        tableView.backgroundView =  nil
        
        let cell = CategoryHomeTableViewCell()
        tableView.register(CategoryHomeTableViewCell.self, forCellReuseIdentifier: CategoryHomeTableViewCell.identifier)
        
        return tableView
    }()

    var categories = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationControllerBackground(color: Color.orange)
        title = "home".localize
        
        setupSubviews()
        categories.append(Category(categoryID: "1", name: "Shoes", imageURL: "https://cdn.techinasia.com/wp-content/uploads/2016/04/shopping-and-ecommerce-750x500.jpg"))
        categories.append(Category(categoryID: "2", name: "Jacket", imageURL: "https://cdn.techinasia.com/wp-content/uploads/2016/04/shopping-and-ecommerce-750x500.jpg"))
        categories.append(Category(categoryID: "3", name: "Watch", imageURL: "https://cdn.techinasia.com/wp-content/uploads/2016/04/shopping-and-ecommerce-750x500.jpg"))
        tableView.reloadData()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension HomeViewController: BaseViewProtocol {
    func setupSubviews() {
        view.addSubview(tableView)
        setupConstraints()
    }
    
    func setupConstraints() {
        tableView.edgeAnchors == view.edgeAnchors
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
