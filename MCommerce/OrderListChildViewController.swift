//
//  OrderListChildViewController.swift
//  MCommerce
//
//  Created by Ambar Septian on 6/22/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit
import CoreLocation
import BGTableViewRowActionWithImage
import Iconic

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
    fileprivate let heightCell:CGFloat = 250
    
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
        order3.histories = [waitingPayment]
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let index = sender as? Int else { return }
        let order = self.orders[index]
        let segueID = Constants.segueID.order.self

        if segue.identifier == segueID.history {
            guard let vc = segue.destination as? OrderHistoryViewController else { return }
            vc.passedOrder = order
        } else if segue.identifier == segueID.note {
            guard let vc = segue.destination as? OrderNoteViewController else { return }
            vc.passedOrder = order

        } else if segue.identifier == segueID.detail {
            guard let vc = segue.destination as? OrderDetailViewController else { return }
            vc.passedOrder = order

        }
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
        return heightCell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: Constants.segueID.order.detail, sender: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // required implement
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let size = heightCell / 6
        let imageSize = CGSize(width:size, height: size)
        let noteIcon = FontAwesomeIcon.fileTextIcon.image(ofSize: imageSize, color: Color.white)
        let historyIcon = FontAwesomeIcon.timeIcon.image(ofSize: imageSize, color: Color.white)
        let cancelIcon = FontAwesomeIcon.removeIcon.image(ofSize: imageSize, color: Color.white)
        let index = indexPath.row
        
        
        let historyButton = BGTableViewRowActionWithImage.rowAction(with: .default, title: "history".localize, backgroundColor: Color.green, image: historyIcon, forCellHeight: UInt(heightCell), andFittedWidth: true) { (action, indexPath) in
            self.performSegue(withIdentifier: Constants.segueID.order.history, sender: index)
        }
        
        let noteButton = BGTableViewRowActionWithImage.rowAction(with: .default, title: "note".localize, backgroundColor: Color.orange, image: noteIcon, forCellHeight: UInt(heightCell)) { (action, indexPath) in
            self.performSegue(withIdentifier: Constants.segueID.order.note, sender: index)
        }
        
        let cancelButton = BGTableViewRowActionWithImage.rowAction(with: .default, title: "cancel".localize, backgroundColor: Color.red, image: cancelIcon, forCellHeight: UInt(heightCell), andFittedWidth: true) { (action, indexPath) in
            
        }
        
        guard orders.count - 1 >= indexPath.row else { return nil }
        guard let status = orders[indexPath.row].lastStatus else { return nil }
        guard historyButton != nil, noteButton != nil, cancelButton != nil else { return nil }
        
        switch status {
        case .waitingPayment:
            return [cancelButton!, historyButton!, noteButton!]
        case .onDelivery:
            return [historyButton!, noteButton!]
        case .cancel, .complete:
            return [historyButton!]
        }
    }
}
