//
//  TagCellCollectionViewCell.swift
//  MCommerce
//
//  Created by Ambar Septian on 6/14/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit

class TagCellCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var maxWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tagLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = Color.white
        tagLabel.textColor = Color.darkGray
        maxWidthConstraint.constant = UIScreen.main.bounds.width - 8 * 2 - 8 * 2
    }

}
