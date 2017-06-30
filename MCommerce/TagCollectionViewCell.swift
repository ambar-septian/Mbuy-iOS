//
//  TagCollectionViewCell.swift
//  MCommerce
//
//  Created by Ambar Septian on 6/14/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit

class TagCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var maxWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tagLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        maxWidthConstraint.constant = UIScreen.main.bounds.width - 8 * 2 - 8 * 2
        self.layer.cornerRadius = 4
        self.backgroundColor = Color.white
    }
    
    
}

extension TagCollectionViewCell {
    func setAppreanceCell(isActive: Bool){
        if isActive {
            backgroundColor = Color.green
            tagLabel.textColor = Color.white
        } else {
            backgroundColor = Color.white
            tagLabel.textColor = Color.darkGray
        }
        
    }
}

extension TagCollectionViewCell: ReuseCollectionCellProtocol {
    static func configureCell<T>(collectionView: UICollectionView, indexPath: IndexPath, object: T?) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! TagCollectionViewCell
        guard let variant = object as? ProductVariant else { return cell }
        
        cell.tagLabel.text = variant.name
        return cell
    }
}
