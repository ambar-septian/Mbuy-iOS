//
//  OrderDetailViewController.swift
//  MCommerce
//
//  Created by Ambar Septian on 6/25/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit

class OrderDetailViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            let cell = CartTableViewCell.self
            tableView.register(cell.nib, forCellReuseIdentifier: cell.identifier)
        }
    }
    
    @IBOutlet weak var tableViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var orderIDLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var quantityHeadingLable: UILabel!
    
    @IBOutlet weak var quantityLabel: UILabel!
    
    @IBOutlet weak var totalHeadingLabel: UILabel!
    
    @IBOutlet weak var subtotalHeadingLabel: UILabel!
    @IBOutlet weak var subtotalLabel: UILabel!

    @IBOutlet weak var deliveryCostHeadingLabel: UILabel! {
        didSet {
            deliveryCostHeadingLabel.text  = "deliveryCost".localize
        }
    }
    
    @IBOutlet weak var deliveryCostLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var statusLabel: RoundedLabel!
    
    
    var passedOrder: Order?
    
    fileprivate var orderCarts: [Cart] {
        get {
            return passedOrder?.carts ?? [Cart]()
        }
        
        set {
            passedOrder?.carts = newValue
            tableView.reloadData()
            tableViewConstraint.constant = tableView.contentSize.height
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadOrder()
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableViewConstraint.constant = tableView.contentSize.height
    }
}

extension OrderDetailViewController {
    func loadOrder(){
        guard let order = passedOrder else { return }
        let orderNo = "orderNo".localize + String(order.orderNumber )
        orderIDLabel.text = orderNo
        navigationItem.title = orderNo
        nameLabel.text = order.profile.name
        addressLabel.text = order.profile.address
        subtotalLabel.text = order.formattedSubtotal
        deliveryCostLabel.text = order.profile.deliveryCost.formattedPrice
        
        
        quantityLabel.text = "\(order.cartQuantity)"
        totalLabel.text = order.formattedTotal
        
        if let status = order.lastStatus {
            statusLabel.text = status.rawValue.localize
            statusLabel.mainColor  = status.color
        }
        
        if let date = order.lastUpdateDate {
            dateLabel.text = date.formattedDate(dateFormat: .dateLong)
            timeLabel.text =  date.formattedDate(dateFormat: .timeMedium)
        }
        
    }
}

extension OrderDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderCarts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cart = orderCarts[indexPath.row]
        let cell = CartTableViewCell.configureCell(tableView: tableView, indexPath: indexPath, object: cart) as! CartTableViewCell
        cell.isStepperHidden = true
        return cell
    }
}
extension OrderDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: Constants.storyboard.product, bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: Constants.viewController.product.detail) as? ProductDetailViewController else { return }
        vc.passedProduct = orderCarts[indexPath.row].product
        pushNavigation(targetVC: vc)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
}
