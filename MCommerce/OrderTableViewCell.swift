//
//  OrderTableViewCell.swift
//  MCommerce
//
//  Created by Ambar Septian on 6/22/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit

class OrderTableViewCell: UITableViewCell {

    @IBOutlet weak var orderIDLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var quantityHeadingLabel: UILabel!
    
    @IBOutlet weak var quantityLabel: UILabel!
    
    @IBOutlet weak var totalHeadingLabel: UILabel!
    
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var statusLabel: RoundedLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension OrderTableViewCell: ReuseTableCellProtocol {
    static func configureCell<T>(tableView: UITableView, indexPath: IndexPath, object: T?) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! OrderTableViewCell
        guard let order = object as? Order else { return cell }
        cell.orderIDLabel.text = "orderNo".localize + (order.orderNumber ?? "")
        cell.nameLabel.text = order.profile.name
        cell.addressLabel.text = order.profile.address

        cell.quantityLabel.text = "\(order.cartQuantity)"
        cell.totalLabel.text = order.formattedTotal
        
        if let status = order.lastStatus {
            cell.statusLabel.text = status.rawValue.localize
            cell.statusLabel.mainColor  = status.color
//            cell.statusLabel.updateConstraints()
            //cell.statusLabel.setNeedsUpdateConstraints()
        }
        
        if let date = order.lastUpdateDate {
            cell.dateLabel.text = date.formattedDate(dateFormat: .dateLong)
            cell.timeLabel.text =  date.formattedDate(dateFormat: .timeMedium)
        }
        
        return cell
    }
}
