//
//  IconLabel.swift
//  MCommerce
//
//  Created by Ambar Septian on 6/25/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit

//
//  BasicLabel.swift
//  MCommerce
//
//  Created by Ambar Septian on 5/15/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit
import Iconic

class IconLabel: UILabel {
    
    var icon: FontAwesomeIcon? {
        didSet {
            guard let iconString = icon?.attributedString(ofSize: font.pointSize, color: textColor) else { return }
            let titleString = NSAttributedString(string: " " + (text ?? ""), attributes: [NSForegroundColorAttributeName: textColor, NSFontAttributeName: font])
            let mutableString = NSMutableAttributedString(attributedString: iconString)
            mutableString.append(titleString)
            attributedText = mutableString
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLabel()
    }
    
    init(text:String, color: UIColor){
        super.init(frame: CGRect.zero)
        self.text = text
        textColor = color
        sizeToFit()
        
        setupLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLabel()
    }
    
    func setupLabel(){
        let pointSize = font.pointSize
        font = Font.latoRegular.withSize(pointSize)
        numberOfLines = 0
    }
}
