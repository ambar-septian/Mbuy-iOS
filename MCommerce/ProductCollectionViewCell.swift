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

    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.heroID = Constants.heroID.productThumbnail
        }
    }

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var ratingView: RatingStarsView!
    
    @IBOutlet weak var ratingCount: UILabel!
    
    @IBOutlet weak var stockLabel: RoundedLabel!
    
    @IBOutlet weak var cartButton: CircleImageButton! {
        didSet {
            cartButton.mainColor = Color.orange
            cartButton.icon = FontAwesomeIcon.shoppingCartIcon
            
        }
    }
    
    @IBOutlet weak var constraintHeight: NSLayoutConstraint!
    
    var currentVC: UIViewController?
    
    fileprivate var product: Product?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    fileprivate var tapAction: ((ProductCollectionViewCell) -> Void)?

    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        guard let attributes = layoutAttributes as? DynamicCollectionLayoutAttributes else {
            return
        }
        
        constraintHeight.constant = attributes.imageHeight
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    
    @IBAction func cartAction(_ sender: Any) {
        guard currentVC != nil else { return }
        guard product != nil else { return }
        let confirmationVC = ProductConfirmationViewController.self
        confirmationVC.showViewController(currentVC: currentVC!, product: product!)
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let convertPoint = cartButton.convert(point, from: self)
        let view = cartButton.hitTest(convertPoint, with: event)
        guard view != nil else {
            return super.hitTest(point, with: event)
        }
        
        return view
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard super.point(inside: point, with: event) else {
            let convertPoint = cartButton.convert(point, from: self)
            let pointInside = cartButton.point(inside:convertPoint, with: event)
            return !cartButton.isHidden && pointInside
        }
        
        return true
    }
}

extension ProductCollectionViewCell: ReuseCollectionCellProtocol {
    static func configureCell<T>(collectionView: UICollectionView, indexPath: IndexPath, object: T?) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! ProductCollectionViewCell
        guard let product = object as? Product else { return cell }
        cell.product = product
        
        cell.imageView.setImage(urlString: product.coverURL, placeholder: .base) { (image) in
            if product.imageSize == nil {
                product.imageSize = image.size
//                collectionView.reloadData()
                collectionView.collectionViewLayout.invalidateLayout()
            }
            
        }
        cell.nameLabel.text = product.name
        cell.priceLabel.text = product.formattedPrice
        cell.stockLabel.text = product.formattedStock
//        cell.ratingView.numberOfStars = product.rating
        
        cell.stockLabel.mainColor = product.stock > 0 ? Color.green : Color.red
        cell.stockLabel.updateConstraints()
//        cell.cartButton.addTarget(self, action: #selector(self.cartButtonTapped(sender:)), for: .touchUpInside)
        
        
        return cell
    }
}


