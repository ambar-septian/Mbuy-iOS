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
import Anchorage

class OrderListChildViewController: BaseViewController {
   
    fileprivate var orders: [Order] {
        let orders = [Order]()
        guard let orderVC = orderParentVC else { return orders }
        
        if currentPage == 0 {
            return orderVC.orders.filter({ $0.lastStatus == .waitingPayment || $0.lastStatus == .onDelivery || $0.lastStatus == .validatingPayment || $0.lastStatus == .prepareOrder  })
        } else {
            return orderVC.orders.filter({ $0.lastStatus == .completed || $0.lastStatus == .canceled })
        }
    }
    
    fileprivate lazy var orderParentVC: OrderListViewController? = {
        guard let pageVC = self.parent as? OrderPageViewController else { return nil }
        return pageVC.parent as? OrderListViewController
    }()

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
    
    fileprivate lazy var emptyView: EmptyDataView =  {
        let view = EmptyDataView(frame: self.view.bounds)
        view.image = #imageLiteral(resourceName: "order")
        view.title = "emptyOrders".localize
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
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
        
        toggleHideEmptyView()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        guard !(isViewAlreadyLoaded) else {
//            return
//        }
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let index = sender as? Int else { return }
        guard let identifier = segue.identifier else { return }
        let order = self.orders[index]
        let segueID = Constants.segueID.order.self
        
        switch identifier {
        case segueID.history:
            guard let vc = segue.destination as? OrderHistoryViewController else { return }
            vc.passedOrder = order
        case segueID.note:
            guard let vc = segue.destination as? OrderNoteViewController else { return }
            vc.passedOrder = order
        case segueID.detail:
            guard let vc = segue.destination as? OrderDetailViewController else { return }
            vc.passedOrder = order
        case segueID.confirmation:
            guard let vc = segue.destination as? OrderConfirmationViewController else { return }
            vc.passedOrder = order
            
        default:
            break
        }
    }
}

extension OrderListChildViewController: BaseViewProtocol {
    func setupSubviews() {
        view.addSubview(emptyView)
        setupConstraints()
    }
    
    func setupConstraints() {
        emptyView.edgeAnchors == self.edgeAnchors
    }
    
    func toggleHideEmptyView(){
        let willHide = orders.count > 0 ? true: false
        emptyView.toggleHide(willHide: willHide)
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
        let size = heightCell / 7
        let imageSize = CGSize(width:size, height: size)
        let noteIcon = FontAwesomeIcon.fileTextIcon.image(ofSize: imageSize, color: Color.white)
        let confirmationIcon = FontAwesomeIcon.fileTextAltIcon.image(ofSize: imageSize, color: Color.white)
        let historyIcon = FontAwesomeIcon.timeIcon.image(ofSize: imageSize, color: Color.white)
        let cancelIcon = FontAwesomeIcon.removeIcon.image(ofSize: imageSize, color: Color.white)
        let completeIcon = FontAwesomeIcon.checkIcon.image(ofSize: imageSize, color: Color.white)
        let index = indexPath.row
        let order = self.orders[index]
        
        
        let historyButton = BGTableViewRowActionWithImage.rowAction(with: .default, title: "history".localize, backgroundColor: Color.green, image: historyIcon, forCellHeight: UInt(heightCell), andFittedWidth: true) { (action, indexPath) in
            self.performSegue(withIdentifier: Constants.segueID.order.history, sender: index)
        }
        
        let noteButton = BGTableViewRowActionWithImage.rowAction(with: .default, title: "note".localize, backgroundColor: Color.orange, image: noteIcon, forCellHeight: UInt(heightCell)) { (action, indexPath) in
            self.performSegue(withIdentifier: Constants.segueID.order.note, sender: index)
        }
        
        let cancelButton = BGTableViewRowActionWithImage.rowAction(with: .default, title: "cancel".localize, backgroundColor: Color.red, image: cancelIcon, forCellHeight: UInt(heightCell), andFittedWidth: true) { (action, indexPath) in
            
//            guard let wIndexPath = indexPath else { return }
          
            Alert.showAlert(message: "cancelAlert".localize, alertType: .okCancel, header: nil, viewController: self, handler: { (alert) in
                
                guard let orderIndex = self.orderParentVC?.orders.index(where: { $0.orderID == order.orderID}) else {
                    return
                }
                
                guard let order = self.orderParentVC?.orders[orderIndex] else { return }
                self.orderParentVC?.controller.cancelOrder(order: order)
                
                self.tableView.reloadData()
                
                guard self.orders.count == 0 else { return }
                self.toggleHideEmptyView()
                
            })
        }
        
        let completeButton = BGTableViewRowActionWithImage.rowAction(with: .default, title: "complete".localize, backgroundColor: Color.lightGreen, image: completeIcon, forCellHeight: UInt(heightCell)) { (action, indexPath) in
            guard let ref = order.ref else { return }
            
            guard let wIndexPath = indexPath else { return }
            
            Alert.showAlert(message: "confirmationAlert".localize, alertType: .okCancel, header: nil, viewController: self, handler: { (alert) in
                
                self.orderParentVC?.controller.postCompleteOrer(ref: ref)
//                
//                self.tableView.beginUpdates()
//                self.tableView.deleteRows(at: [wIndexPath], with: .automatic)
//                self.tableView.endUpdates()
//                
                self.tableView.reloadData()
                
                guard self.orders.count == 0 else { return }
                self.toggleHideEmptyView()

                
            })
        }
        
        let confirmationButton = BGTableViewRowActionWithImage.rowAction(with: .default, title: "confirmation".localize, backgroundColor: Color.yellow, image: confirmationIcon, forCellHeight: UInt(heightCell), andFittedWidth: true) { (action, indexPath) in
            self.performSegue(withIdentifier: Constants.segueID.order.confirmation, sender: index)
        }
        
        
        guard orders.count - 1 >= indexPath.row else { return nil }
        guard let status = orders[indexPath.row].lastStatus else { return nil }
        guard historyButton != nil, noteButton != nil, cancelButton != nil else { return nil }
        
        switch status {
        case .waitingPayment:
            return [cancelButton!, historyButton!, noteButton!]
        case .validatingPayment, .prepareOrder:
            return [historyButton!, confirmationButton!]
        case .onDelivery:
            return [historyButton!, confirmationButton!, completeButton!]
        case .canceled, .completed:
            return [historyButton!]
        }
    }
}
