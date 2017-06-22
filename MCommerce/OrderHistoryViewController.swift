//
//  OrderListViewController.swift
//  MCommerce
//
//  Created by Ambar Septian on 6/21/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit

class OrderHistoryViewController: BaseViewController {

    var passedOrder: Order?
    
    var orderHistories: [OrderHistory] {
        get {
            return passedOrder?.histories ?? [OrderHistory]()
        }
        
        set {
            passedOrder?.histories = newValue.sorted(by: { $0.date < $1.date })
            tableView.reloadData()
            tableViewConstraint.constant = tableView.contentSize.height
        }
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            let cell = OrderHistoryTableViewCell.self
            tableView.register(cell.nib, forCellReuseIdentifier: cell.identifier)
        }
    }
    
    @IBOutlet weak var tableViewConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.reloadData()
//        passedOrder = Order(orderID: "1")
//        let history1 = OrderHistory(date: Date(), status: .complete)
//        let history2 = OrderHistory(date: Date(), status: .complete)
//        let history3 = OrderHistory(date: Date(), status: .complete)
//        passedOrder?.histories = [history1, history2, history3]
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension OrderHistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderHistories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let history = orderHistories[indexPath.row]
        return OrderHistoryTableViewCell.configureCell(tableView: tableView, indexPath: indexPath, object: history)
    }
}

extension OrderHistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
}
