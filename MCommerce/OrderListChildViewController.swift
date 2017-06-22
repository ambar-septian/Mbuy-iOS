//
//  OrderListChildViewController.swift
//  MCommerce
//
//  Created by Ambar Septian on 6/22/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit
import CoreLocation

class OrderListChildViewController: BaseViewController {
    
    var orders = [Order]() {
        didSet {
            tableView.reloadData()
        }
    }

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            let cell = OrderTableViewCell.self
            tableView.register(cell.nib, forCellReuseIdentifier: cell.identifier)
        }
    }
    
    fileprivate var isViewAlreadyLoaded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let profile = OrderProfile(firstName: "Ambuy", lastName: "Septian", address: "Jl. Letjen Sparaman No.3 Jakarta Selatan", coordinate: CLLocationCoordinate2DMake(-6, 102), phone: "032423423", email: "asdfds@gmail.com")
        
        let category = Category(categoryID: "1", name: "a", imageURL: "")
        let product1 = Product(productID: "1", name: "Sepatu Nike", category: category, imageURL: "https://images-eu.ssl-images-amazon.com/images/G/31/img15/Shoes/CatNav/k._V293117556_.jpg", stock: 30, description: "In a storyboard-based application, you will often want to do a", price: 50000, createdDate: Date())
        let cart1 = Cart(product: product1, price: product1.price, quantity: 4)
        let cart2 = Cart(product: product1, price: product1.price, quantity: 20)
        let cart3 = Cart(product: product1, price: product1.price, quantity: 10)
        
        let cancel = OrderHistory(date: Date(), status: .cancel)
        let completed = OrderHistory(date: Date(), status: .complete)
        let waitingPayment = OrderHistory(date: Date(), status: .waitingPayment)
        let onDelivery = OrderHistory(date: Date(), status: .onDelivery)
        
        let order1 = Order(orderID: "001", profile: profile)
        order1.histories = [waitingPayment, onDelivery]
        order1.carts = [cart1, cart2]
        
        let order2 = Order(orderID: "001", profile: profile)
        order2.histories = [waitingPayment, onDelivery, completed]
        order2.carts = [cart2, cart3]
        
        let order3 = Order(orderID: "001", profile: profile)
        order3.histories = [waitingPayment, onDelivery, cancel]
        order3.carts = [cart1, cart2]
        
        orders = [order1, order2, order3]
       
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard !(isViewAlreadyLoaded) else {
            return
        }
        
        tableView.reloadData()
        isViewAlreadyLoaded = true

    }
}

extension OrderListChildViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let order = orders[indexPath.row]
        return OrderTableViewCell.configureCell(tableView: tableView, indexPath: indexPath, object: order)
    }
}

extension OrderListChildViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let vc = storyboard?.instantiateViewController(withIdentifier: Constants.viewController.order.OrderHistoryViewController) as? OrderListChildViewController
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // required implement
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let noteButton = UITableViewRowAction(style: .default, title: "note".localize) { (action, indexPath) in
            //
        }
        noteButton.backgroundColor = Color.orange
        
        let historyButton = UITableViewRowAction(style: .default, title: "history".localize) { (action, indexPath) in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: Constants.viewController.order.history) as! OrderHistoryViewController
            vc.passedOrder = self.orders[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
        historyButton.backgroundColor = Color.green
        
        let cancelButton = UITableViewRowAction(style: .default, title: "cancel".localize) { (action, indexPath) in
            //
        }
        cancelButton.backgroundColor = Color.green

        guard let status = orders[indexPath.row].lastStatus else { return nil }
        switch status {
        case .waitingPayment:
            return [cancelButton, noteButton, historyButton]
        case .onDelivery:
            return [noteButton, historyButton]
        case .cancel, .complete:
            return [historyButton]
        }
    }
}
