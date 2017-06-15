//
//  SimpleProductListCollectionViewCell.swift
//  MCommerce
//
//  Created by Ambar Septian on 6/13/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit

class SimpleProductCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
//    override var contentView: RoundedView
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

}

extension SimpleProductCollectionViewCell: ReuseCollectionCellProtocol {
    static func configureCell<T>(collectionView: UICollectionView, indexPath: IndexPath, object: T?) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! SimpleProductCollectionViewCell
        guard let product = object as? Product else { return cell }
        
        cell.imageView.setImage(urlString: product.coverURL)
        cell.nameLabel.text = product.name
        cell.priceLabel.text = product.formattedPrice
        return cell
    }
}
