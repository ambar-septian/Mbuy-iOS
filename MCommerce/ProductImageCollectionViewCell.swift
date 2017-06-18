//
//  ProductImageCollectionViewCell.swift
//  MCommerce
//
//  Created by Ambar Septian on 6/14/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit
import Anchorage

class ProductImageCollectionViewCell: UICollectionViewCell {
    
    lazy var productImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.heroID = Constants.heroID.productPreview
        
        return imageView
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
}

extension ProductImageCollectionViewCell: BaseViewProtocol {
    func setupSubviews() {
        contentView.addSubview(productImageView)
     
        backgroundColor = Color.clear
        clipsToBounds = true
        
        setupConstraints()
        
    }
    
    func setupConstraints() {
        productImageView.edgeAnchors == contentView.edgeAnchors
        
    }
}

extension ProductImageCollectionViewCell: ReuseCollectionCellProtocol {
    static func configureCell<T>(collectionView: UICollectionView, indexPath: IndexPath, object: T?) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! ProductImageCollectionViewCell
        guard let imageURL = object as? String else { return cell }
       
        cell.productImageView.setImage(urlString: imageURL)
        return cell
    }
}
