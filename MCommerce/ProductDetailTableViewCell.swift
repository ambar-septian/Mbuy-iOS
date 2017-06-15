//
//  DescriptionTableViewCell.swift
//  MCommerce
//
//  Created by Ambar Septian on 6/13/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit

class ProductDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var fieldLabel: UILabel!
    
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension ProductDetailTableViewCell: ReuseTableCellProtocol {
    static func configureCell<T>(tableView: UITableView, indexPath: IndexPath, object: T?) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as!
        ProductDetailTableViewCell
        guard let productDetail = object as? ProductDetail else { return cell }
        
        cell.fieldLabel.text = productDetail.field
        cell.valueLabel.text = productDetail.value
        cell.backgroundColor = indexPath.row % 2 == 0 ? Color.white : Color.lightGrayTableCell
        
        return cell
        
    }
}
