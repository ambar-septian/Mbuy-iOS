//
//  ProductCollectionViewCell.swift
//  MCommerce
//
//  Created by Ambar Septian on 5/28/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit
import Iconic

class ProductCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var ratingView: RatingStarsView!
    
    @IBOutlet weak var stockLabel: RoundedLabel! {
        didSet {
            stockLabel.mainColor = Color.green
        }
    }
    
    @IBOutlet weak var cartButton: CircleImageButton! {
        didSet {
            cartButton.mainColor = Color.orange
            cartButton.icon = FontAwesomeIcon.shoppingCartIcon
        }
    }
    
    @IBOutlet weak var constraintHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        guard let attributes = layoutAttributes as? DynamicCollectionLayoutAttributes else {
            return
        }
        
        constraintHeight.constant = attributes.imageHeight
        setupView()
    }
    
}

extension ProductCollectionViewCell: RoundedShadowProtocol {
    func setupView(){
        self.backgroundColor = Color.white
        setRoundedLayer(view: self)
    }
}

extension ProductCollectionViewCell: ReuseCollectionCellProtocol {
    static func configureCell<T>(collectionView: UICollectionView, indexPath: IndexPath, object: T?) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! ProductCollectionViewCell
        guard let product = object as? Product else { return cell }
        
        cell.imageView.setImage(urlString: product.imageURL) { (image) in
            if product.imageSize == nil {
                product.imageSize = image.size
                collectionView.collectionViewLayout.invalidateLayout()
            }
            
        }
        cell.nameLabel.text = product.name
        cell.priceLabel.text = product.formattedPrice
        cell.stockLabel.text = product.formattedStock
        cell.ratingView.numberOfStars = product.rating
        
        return cell
    }
}


