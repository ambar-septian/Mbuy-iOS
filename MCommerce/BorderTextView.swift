//
//  BorderTextView.swift
//  MCommerce
//
//  Created by Ambar Septian on 6/25/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit

import UIKit

class BorderTextView: UITextView {
    

    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setupTextView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupTextView()
        
    }
}

extension BorderTextView {
    fileprivate func setupTextView(){
        layer.backgroundColor = Color.white.cgColor
        
        layer.masksToBounds = false
        layer.shadowColor = Color.orange.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 0.0
        
        font = Font.latoBold
        textColor = Color.orange
        
        isScrollEnabled = false
    }
    
    
}
