//
//  ProductListCollectionViewCell.swift
//  MCommerce
//
//  Created by Ambar Septian on 5/15/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit
import Anchorage
import Iconic

class ProductListCollectionViewCell: UICollectionViewCell {
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = Font.latoRegular.withSize(16)
        label.textColor = Color.lightGray
        return label
    }()
    
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = Font.latoBold.withSize(14)
        label.textColor = Color.orange
        return label
    }()
    
   
    lazy var ratingView: RatingStarsView = {
        let ratingView = RatingStarsView()
        return ratingView
    }()
    
    lazy var cartButton: CircleImageButton = {
        let button = CircleImageButton(backgroundColor: Color.orange, icon: FontAwesomeIcon.shoppingCartIcon)
        return button
    }()
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
