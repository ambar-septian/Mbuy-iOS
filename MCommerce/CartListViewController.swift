//
//  CartListViewController.swift
//  MCommerce
//
//  Created by Ambar Septian on 6/21/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit

class CartListViewController: BaseViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            let cell = CartTableViewCell.self
            tableView.register(cell.nib, forCellReuseIdentifier: cell.identifier)
        }
    }
    
    @IBOutlet weak var quantityHeadingLabel: UILabel!
    
    @IBOutlet weak var quantityLabel: UILabel!
    
    @IBOutlet weak var subtotalHeadingLabel: UILabel!
    
    @IBOutlet weak var subtotalLabel: UILabel!
    
    @IBOutlet weak var tableViewConstraint: NSLayoutConstraint!
    
    fileprivate var carts = [Cart]() {
        didSet {
            tableView.reloadData()
            tableViewConstraint.constant = tableView.contentSize.height
            
            quantityLabel.text = "\(quantity)"
            subtotalLabel.text = subtotal.formattedPrice
        }
    }
    
    fileprivate var quantity:Int {
        return carts.reduce(0, { $0 + $1.quantity })
    }
    
    fileprivate var subtotal:Double {
        return carts.reduce(0, { $0 + ($1.product.price * Double($1.quantity)) })
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let category = Category(categoryID: "1", name: "a", imageURL: "")
        let product1 = Product(productID: "1", name: "Sepatu Nike", category: category, imageURL: "https://images-eu.ssl-images-amazon.com/images/G/31/img15/Shoes/CatNav/k._V293117556_.jpg", stock: 30, description: "In a storyboard-based application, you will often want to do a", price: 50000, createdDate: Date())
        let cart1 = Cart(product: product1, price: product1.price, quantity: 4)
        let cart2 = Cart(product: product1, price: product1.price, quantity: 20)
        let cart3 = Cart(product: product1, price: product1.price, quantity: 10)
        
        carts = [cart1, cart2, cart3]
        NotificationCenter.default.addObserver(self, selector: #selector(updateFooterLabel), name: Constants.notification.updateStepper, object: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension CartListViewController {
    func updateFooterLabel(){
        quantityLabel.text = "\(quantity)"
        subtotalLabel.text = subtotal.formattedPrice
    }
}

extension CartListViewController {
    @IBAction func checkoutDidTapped(_ sender: Any) {
    }
}

extension CartListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return carts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cart = carts[indexPath.row]
        return CartTableViewCell.configureCell(tableView: tableView, indexPath: indexPath, object: cart)
    }
}

extension CartListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: Constants.storyboard.product, bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: Constants.viewController.product.detail) as? ProductDetailViewController else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // required implement
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteButton = UITableViewRowAction(style: .default, title: "delete".localize) { (action, indexPath) in
            //
        }
        deleteButton.backgroundColor = Color.red
        return [deleteButton]
    }
}
