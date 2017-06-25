//
//  BorderTextField.swift
//  MCommerce
//
//  Created by Ambar Septian on 6/25/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit

class BorderTextField: UITextField {

    override var placeholder: String? {
        didSet {
            guard placeholder != nil else { return }
            let attributes = [
                NSForegroundColorAttributeName: Color.lightGray,
                NSFontAttributeName : Font.latoRegular
            ]
            
            attributedPlaceholder = NSAttributedString(string: placeholder!, attributes:attributes)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTextField()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupTextField()
        
    }
}

extension BorderTextField {
    fileprivate func setupTextField(){
        borderStyle = .none
        layer.backgroundColor = Color.white.cgColor
        
        layer.masksToBounds = false
        layer.shadowColor = Color.orange.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 0.0
        
        font = Font.latoBold
        textColor = Color.orange
    }
    
    
}
