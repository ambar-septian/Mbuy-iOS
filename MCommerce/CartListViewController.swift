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
import Anchorage

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
            let willHide = carts.count > 0 ? true: false
            emptyView.toggleHide(willHide: willHide)
        }
    }
    
    fileprivate var quantity:Int {
        return carts.reduce(0, { $0 + $1.quantity })
    }
    
    fileprivate var subtotal:Double {
        return carts.reduce(0, { $0 + ($1.product.price * Double($1.quantity)) })
    }
    
    fileprivate let heightCell:CGFloat = 120
    
    fileprivate let controller = CartController()
    
    fileprivate lazy var emptyView: EmptyDataView =  {
        let view = EmptyDataView(frame: self.view.bounds)
        view.image = #imageLiteral(resourceName: "basket")
        view.title = "emptyCart".localize
        
        return view
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateFooterLabel), name: Constants.notification.updateStepper, object: nil)
        
        loadCartList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "cart".localize
        
        TabBarBadge.shared.cartCount = 0
        loadCartList()
        
        setupSubviews()
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        controller.removeHandlerCartList()
    }
}

extension CartListViewController {
    func loadCartList(){
        showProgressHUD()
        DispatchQueue.global().async {
            self.controller.getListCarts(completion: { (carts) in
                DispatchQueue.main.async {
                    self.hideProgressHUD()
                    self.carts = carts
                }
            })
        }
    }
    
    func updateFooterLabel(){
        quantityLabel.text = "\(quantity)"
        subtotalLabel.text = subtotal.formattedPrice
    }
}

extension CartListViewController: BaseViewProtocol {
    func setupSubviews() {
        view.addSubview(emptyView)
        setupConstraints()
    }
    
    func setupConstraints() {
        emptyView.edgeAnchors == view.edgeAnchors
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
        vc.passedProduct = carts[indexPath.row].product
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
            guard let wIndexPath = indexPath else { return }
            let index = wIndexPath.row
            
            self.controller.deleteCart(cart: self.carts[index])
            
            self.tableView.beginUpdates()
            self.carts.remove(at: index)
            self.tableView.deleteRows(at: [wIndexPath], with: .automatic)
            self.tableView.endUpdates()
        }
        
        guard deleteButton != nil else { return nil }
        return [deleteButton!]
    }
}
