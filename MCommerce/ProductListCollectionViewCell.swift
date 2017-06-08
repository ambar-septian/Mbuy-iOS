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

class ProductListCollectionViewCell: UICollectionViewCell, RoundedShadowProtocol, ReuseCellProtocol {
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = Font.latoRegular.withSize(16)
        label.textColor = Color.lightGray
        label.numberOfLines = 0
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
    
    lazy var stockLabel: RoundedLabel = {
        let label = RoundedLabel(text: "", color: Color.green)
        return label
    }()
    
    
    init(){
        super.init(frame: CGRect.zero)
        setupSubviews()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        guard let attributes = layoutAttributes as? DynamicCollectionLayoutAttributes else {
            return
        }
        
        imageView.heightAnchor == attributes.imageHeight
    }
    
    
}

extension ProductListCollectionViewCell: BaseViewProtocol {
    func setupSubviews() {
        setRoundedLayer(view: contentView)
        
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(ratingView)
        contentView.addSubview(stockLabel)
        contentView.addSubview(cartButton)
        
        backgroundColor = Color.cream
        clipsToBounds = true
        
        setupConstraints()
        
    }
    
    func setupConstraints() {
        imageView.topAnchor == contentView.topAnchor
        imageView.horizontalAnchors == contentView.horizontalAnchors
//        imageView.heightAnchor == 50
        
        nameLabel.topAnchor == imageView.bottomAnchor + 10
        nameLabel.horizontalAnchors == imageView.horizontalAnchors + 12
        
        priceLabel.topAnchor == nameLabel.bottomAnchor + 5
        priceLabel.horizontalAnchors == nameLabel.horizontalAnchors
        
        ratingView.topAnchor == priceLabel.bottomAnchor + 8
        ratingView.horizontalAnchors == priceLabel.horizontalAnchors
        ratingView.bottomAnchor == cartButton.topAnchor + 10
        ratingView.heightAnchor == 10
        
        cartButton.topAnchor == ratingView.bottomAnchor + 10
        cartButton.trailingAnchor == priceLabel.trailingAnchor
        cartButton.bottomAnchor == contentView.bottomAnchor + 10
        cartButton.heightAnchor == 30
        
        stockLabel.leadingAnchor == priceLabel.leadingAnchor
//        stockLabel.verticalAnchors == cartButton.verticalAnchors
        stockLabel.heightAnchor == 20
        
        
        
    }
}

extension ProductListCollectionViewCell: ReuseCollectionCellProtocol {
    static func configureCell<T>(collectionView: UICollectionView, indexPath: IndexPath, object: T?) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! ProductListCollectionViewCell
        guard let product = object as? Product else { return cell }
        
        cell.imageView.setImage(urlString: product.imageURL) { (image) in
            product.imageSize = image.size
        }
        cell.nameLabel.text = product.name
        cell.priceLabel.text = product.formattedPrice
        cell.stockLabel.text = product.formattedStock
        cell.ratingView.numberOfStars = product.rating
        
        return cell
    }
}
