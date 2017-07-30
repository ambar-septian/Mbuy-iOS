//
//  OrderPaymentCollectionViewCell.swift
//  MCommerce
//
//  Created by Ambar Septian on 6/22/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit

class OrderPaymentCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var bankNameLabel: UILabel!
    
    @IBOutlet weak var accountNameLabel: UILabel!
    
    
    @IBOutlet weak var accountNumberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

extension OrderPaymentCollectionViewCell: ReuseCollectionCellProtocol {
    static func configureCell<T>(collectionView: UICollectionView, indexPath: IndexPath, object: T?) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! OrderPaymentCollectionViewCell
        guard let payment = object as? BankPayment else { return cell }
        cell.accountNumberLabel.text = payment.accountNumber
        cell.bankNameLabel.text = payment.bankName
        cell.accountNameLabel.text = payment.accountName
        cell.imageView.image = payment.image

        return cell
    }
}
