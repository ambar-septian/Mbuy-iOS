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
    
    var cart: Cart?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        stepper.delegate = self
        // Initialization code
    }
    @IBOutlet weak var stepper: RoundedStepper!

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension CartTableViewCell: ReuseTableCellProtocol {
    static func configureCell<T>(tableView: UITableView, indexPath: IndexPath, object: T?) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! CartTableViewCell
        guard let cart = object as? Cart else { return cell }
        
        cell.cart = cart
        cell.productImageView.setImage(urlString: cart.product.coverURL)
        cell.nameLabel.text = cart.product.name
        cell.priceLabel.text = cart.formattedPrice
        cell.stepper.counter = cart.quantity
        
        return cell
    }
}

extension CartTableViewCell:RoundedStepperDelegate {
    func stepperValueDidUpdate(value: Int) {
        cart?.quantity = value
        NotificationCenter.default.post(name: Constants.notification.updateStepper, object: nil, userInfo: nil)
    }
}
