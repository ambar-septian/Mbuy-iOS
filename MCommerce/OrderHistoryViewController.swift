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
            let histories = passedOrder?.histories ?? [OrderHistory]()
            return histories.sorted(by: { $0.date > $1.date })
        }
        
        set {
            passedOrder?.histories = newValue
            tableView.reloadData()
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
        navigationItem.title = "history".localize
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
        tableViewConstraint.constant = tableView.contentSize.height + 150
        tableView.layoutIfNeeded()
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
