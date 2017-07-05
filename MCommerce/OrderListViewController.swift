//
//  OrderListViewController.swift
//  MCommerce
//
//  Created by Ambar Septian on 6/22/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit
import Anchorage

protocol OrderParentProtocol: class {
    func didChildPageChange(index:Int)
    func didOrderFinishLoad(index: Int)
}

class OrderListViewController: BaseViewController {

    @IBOutlet weak var processButton: BasicButton!
    
    @IBOutlet weak var completeButton: BasicButton!
    
    @IBOutlet weak var tabView: UIView!
    
    @IBOutlet weak var childView: UIView!
    
    @IBOutlet weak var lineIndicatorView: UIView!
    
    fileprivate var lineLeadingConstraint: NSLayoutConstraint? {
        return tabView.constraints.filter({ $0.identifier == "leadingConstraint"}).first
    }
    
    weak var delegate: OrderParentProtocol?
    
    var activePageIndex = 0
    
    fileprivate var controller = OrderController()
    
    var orders = [Order]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupChildView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "orders".localize
        loadOrders()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        controller.removeOrderListHandler()
    }
    
}

extension OrderListViewController {
    @IBAction func changeButtonDidTapped(_ sender: Any) {
        guard let row = (sender as? UIButton)?.tag else { return }
        didChangeChildPage(row: row)
    }

}

extension OrderListViewController {
    fileprivate func loadOrders(){
        showProgressHUD()
        DispatchQueue.global().async {
            self.controller.listOrders(completion: { (orders) in
                DispatchQueue.main.async {
                    self.hideProgressHUD()
                    self.orders = orders.sorted(by: { $0.orderNumber < $1.orderNumber })
                    self.delegate?.didOrderFinishLoad(index: self.activePageIndex)
                }
                
            })
        }
    }
    
    fileprivate func setupChildView(){
        guard let vc = storyboard?.instantiateViewController(withIdentifier: Constants.viewController.order.page) as? OrderPageViewController else { return }
//        vc.childDelegate = self
        addChildViewController(vc)
        vc.view.frame = childView.bounds
        childView.addSubview(vc.view)
        vc.didMove(toParentViewController: self)
    }
    
    func didChangeChildPage(row:Int, withChangePage:Bool = true){
        let tabButtons = [processButton, completeButton]
        for (index, button) in tabButtons.enumerated() {
            if index == row  {
                guard activePageIndex != index else { return }
                
                button?.setTitleColor(Color.orange, for: .normal)
                self.lineLeadingConstraint?.constant = index == tabButtons.count - 1 ? self.view.bounds.width * 0.5 : 0
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                    self.view.layoutIfNeeded()
                    
                }, completion: nil)
                activePageIndex = index
                if withChangePage {
                    delegate?.didChildPageChange(index: index)
                }
            } else {
                button?.setTitleColor(Color.lightGray, for: .normal)
            }
        }
        
    }
}
