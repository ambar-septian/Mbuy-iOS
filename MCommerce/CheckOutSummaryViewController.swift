//
//  CheckOutSummaryViewController.swift
//  MCommerce
//
//  Created by Ambar Septian on 6/25/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit
import Iconic

class CheckOutSummaryViewController: BaseViewController {

    @IBOutlet weak var firstNameHeadingLabel: IconLabel! {
        didSet {
            firstNameHeadingLabel.icon = FontAwesomeIcon.userIcon
        }
    }
    
    @IBOutlet weak var firstNameLabel: UILabel!
    
    
    @IBOutlet weak var lastNameHeadingLabel: IconLabel! {
        didSet {
            lastNameHeadingLabel.icon = FontAwesomeIcon.userIcon
        }
    }
    
    @IBOutlet weak var lastNameLabel: UILabel!
    
    @IBOutlet weak var emailHeadingLabel: IconLabel! {
        didSet {
            emailHeadingLabel.icon = FontAwesomeIcon.envelopeIcon
        }
    }
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var phoneHeadingLabel: IconLabel! {
        didSet {
            phoneHeadingLabel.icon = FontAwesomeIcon.mobilePhoneIcon
        }
    }
    
    @IBOutlet weak var phoneLabel: UILabel!
    
    @IBOutlet weak var addressHeadingLabel: IconLabel! {
        didSet {
            addressHeadingLabel.icon = FontAwesomeIcon.homeIcon
        }
    }
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var noteHeadingLabel: IconLabel! {
        didSet {
            noteHeadingLabel.icon = FontAwesomeIcon.editIcon
        }
    }
    
    @IBOutlet weak var noteLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            let cell = CartTableViewCell.self
            tableView.register(cell.nib, forCellReuseIdentifier: cell.identifier)
        }
    }
    
    @IBOutlet weak var tableViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var subtotalHeadingLabel: IconLabel!
    
    @IBOutlet weak var subtotalLabel: UILabel!
    
    @IBOutlet weak var deliveryCostHeadingLabel: IconLabel!
    
    @IBOutlet weak var deliveryLabel: UILabel!
    
    @IBOutlet weak var totalHeadingLabel: IconLabel!
    
    @IBOutlet weak var totalLabel: UILabel!
    
    fileprivate lazy var carts: [Cart] = {
        let carts = [Cart]()
        
        guard let pageVC = self.parent as? CheckOutPageViewController else { return carts }
        guard let mainVC = pageVC.parent as? CheckOutMainViewController else { return carts }
        
        return mainVC.passedCarts
    }()
    
    fileprivate var subTotal:Double = 0
    
    fileprivate var deliveryCost: Double = 0
    
    fileprivate var total:Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.reloadData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupOrder()
    }
}

extension CheckOutSummaryViewController {
    func setupOrder(){
        tableViewConstraint.constant = tableView.contentSize.height
        
        guard let pageVC = parent as? CheckOutPageViewController else { return }
        guard let mainVC = pageVC.parent as? CheckOutMainViewController else { return }
        
        let profile = mainVC.profile
        firstNameLabel.text = profile.firstName
        lastNameLabel.text = profile.lastName
        emailLabel.text = profile.email
        phoneLabel.text = profile.phone
        addressLabel.text = profile.address
        noteLabel.text = profile.note
        
        subTotal =  carts.reduce(0, { $0 + ($1.product.price * Double($1.quantity)) })
        deliveryCost = mainVC.currentDeliveryCost
        
        subtotalLabel.text = subTotal.formattedPrice
        deliveryLabel.text = deliveryCost.formattedPrice
        
        total = subTotal + deliveryCost
        totalLabel.text = total.formattedPrice
        
    }
}

extension CheckOutSummaryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return carts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cart = carts[indexPath.row]
        let cell = CartTableViewCell.configureCell(tableView: tableView, indexPath: indexPath, object: cart) as! CartTableViewCell
        cell.isStepperHidden = true
        return cell
    }
}

extension CheckOutSummaryViewController: UITableViewDelegate {
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

