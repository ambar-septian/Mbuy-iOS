//
//  CartTableViewCell.swift
//  MCommerce
//
//  Created by Ambar Septian on 6/21/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit

class CartTableViewCell: UITableViewCell {

    @IBOutlet weak var productImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var variantLabel: UILabel!
    
    @IBOutlet weak var quantityLabel: UILabel!
    
    fileprivate var quantityString: String {
        return "Quantity: \(cart?.quantity ?? 0)"
    }
    
    var cart: Cart?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        stepper.delegate = self
        // Initialization code
    }
    @IBOutlet weak var stepper: RoundedStepper!

    @IBOutlet weak var stepperParentView: UIView!
    
    var isStepperHidden:Bool = false{
        didSet {
            stepperParentView.isHidden = true
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.image = nil
    }
}

extension CartTableViewCell: ReuseTableCellProtocol {
    static func configureCell<T>(tableView: UITableView, indexPath: IndexPath, object: T?) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! CartTableViewCell
        guard let cart = object as? Cart else { return cell }
        
        cell.cart = cart
        cell.productImageView.setImage(urlString: cart.product.coverURL, placeholder: .base)
        cell.nameLabel.text = cart.product.name
        cell.priceLabel.text = (cart.price * Double(cart.quantity)).formattedPrice
        cell.stepper.counter = cart.quantity
        cell.quantityLabel.text = cell.quantityString
        cell.variantLabel.text = cart.variant?.name ?? ""
        return cell
    }
}

extension CartTableViewCell:RoundedStepperDelegate {
    func stepperValueDidUpdate(value: Int) {
        guard let cart = self.cart else { return }
        cart.quantity = value
        quantityLabel.text = quantityString
        priceLabel.text = (cart.price * Double(cart.quantity)).formattedPrice
        
        let controller = CartController()
        controller.updateCartList(cart: cart, quantity: value)
        
        NotificationCenter.default.post(name: Constants.notification.updateStepper, object: nil, userInfo: nil)
    }
}
