//
//  CartListViewController.swift
//  MCommerce
//
//  Created by Ambar Septian on 6/21/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit
import BGTableViewRowActionWithImage
import Iconic

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
    
    fileprivate let heightCell:CGFloat = 120
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let category = Category(nameID: "1", nameEN: "a", imageURL: "", orderNumber: 0)
        let product1 = Product(productID: "1", name: "Sepatu Nike", category: category, imageURL: "https://images-eu.ssl-images-amazon.com/images/G/31/img15/Shoes/CatNav/k._V293117556_.jpg", stock: 30, description: "In a storyboard-based application, you will often want to do a", price: 50000, createdDate: Date())
        let cart1 = Cart(product: product1, price: product1.price, quantity: 4)
        let cart2 = Cart(product: product1, price: product1.price, quantity: 20)
        let cart3 = Cart(product: product1, price: product1.price, quantity: 10)
        
        carts = [cart1, cart2, cart3]
        NotificationCenter.default.addObserver(self, selector: #selector(updateFooterLabel), name: Constants.notification.updateStepper, object: nil)
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "cart".localize
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.segueID.checkout.main {
            guard let nav = segue.destination as? UINavigationController else { return }
            guard let vc = nav.topViewController as? CheckOutMainViewController else { return }
            vc.passedCarts = carts
        }
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
        performSegue(withIdentifier: Constants.segueID.checkout.main, sender: nil)
    }
}

extension CartListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return carts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cart = carts[indexPath.row]
        let cell =  CartTableViewCell.configureCell(tableView: tableView, indexPath: indexPath, object: cart) as! CartTableViewCell
        cell.quantityLabel.isHidden = true
        
        return cell
    }
}

extension CartListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: Constants.storyboard.product, bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: Constants.viewController.product.detail) as? ProductDetailViewController else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightCell
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

        let size = heightCell / 6
        let imageSize = CGSize(width:size, height: size)
        let icon = FontAwesomeIcon.trashIcon.image(ofSize: imageSize, color: Color.white)
        let deleteButton = BGTableViewRowActionWithImage.rowAction(with: .default, title: "delete".localize, backgroundColor: Color.red, image: icon, forCellHeight: UInt(heightCell), andFittedWidth: true) { (action, indexPath) in
            //
        }
        
        guard deleteButton != nil else { return nil }
        return [deleteButton!]
    }
}
