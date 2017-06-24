//
//  ImageTableViewRowAction.swift
//  MCommerce
//
//  Created by Ambar Septian on 6/23/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit

class ImageTableViewRowAction: UITableViewRowAction {
    var image: UIImage?
    
    
    func _setButton(button: UIButton)
    {
        if let image = image, let titleLabel = button.titleLabel
        {
            let labelString = NSString(string: titleLabel.text!)
            let titleSize = labelString.size(attributes: [NSFontAttributeName: titleLabel.font])
            
            button.tintColor = UIColor.white
            button.setImage(image, for: .normal)
            button.imageEdgeInsets.right = -titleSize.width
        }
    }
}
