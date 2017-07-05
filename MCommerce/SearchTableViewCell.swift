//
//  SearchTableViewCell.swift
//  MCommerce
//
//  Created by Ambar Septian on 7/4/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productImageView: UIImageView! {
        didSet {
            productImageView.heroID = Constants.heroID.productThumbnail
        }
    }
    
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var stockLabel: RoundedLabel!
    
    @IBOutlet weak var ratingView: RatingStarsView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

extension SearchTableViewCell: ReuseTableCellProtocol {
    static func configureCell<T>(tableView: UITableView, indexPath: IndexPath, object: T?) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! SearchTableViewCell
        guard let product = object as? Product else { return cell }
        cell.nameLabel.text = product.name
        cell.priceLabel.text = product.formattedPrice
        //        cell.stockLabel.text = product.formattedStock
        //        cell.stockLabel.mainColor = product.stock > 0 ? Color.green : Color.red
        //        cell.ratingView.numberOfStars = product.rating
        cell.productImageView.setImage(urlString: product.coverURL)
//        cell.productImageView.updateConstraints()
        
        return cell
        
    }
}

