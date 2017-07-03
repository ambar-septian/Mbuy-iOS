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
   
    fileprivate var orders: [Order] {
        let orders = [Order]()
        guard let pageVC = self.parent as? OrderPageViewController else { return orders }
        guard let orderVC = pageVC.parent as? OrderListViewController else { return orders }
        
        if currentPage == 0 {
            return orderVC.orders.filter({ $0.lastStatus == .waitingPayment || $0.lastStatus == .onDelivery })
        } else {
            return orderVC.orders.filter({ $0.lastStatus == .complete || $0.lastStatus == .cancel })
        }
    }

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            let cell = OrderTableViewCell.self
            tableView.register(cell.nib, forCellReuseIdentifier: cell.identifier)
        }
    }
    
    @IBOutlet weak var tableViewConstraint: NSLayoutConstraint!
    
    fileprivate var isViewAlreadyLoaded = false
    fileprivate let heightCell:CGFloat = 250
    var currentPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        tableView.reloadData()
        isViewAlreadyLoaded = true
        tableViewConstraint.constant = tableView.contentSize.height

        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        guard !(isViewAlreadyLoaded) else {
//            return
//        }
       
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
