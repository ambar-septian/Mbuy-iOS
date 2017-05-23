//
//  BasicLabel.swift
//  MCommerce
//
//  Created by Ambar Septian on 5/15/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit

class BasicLabel: UILabel {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
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
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLabel(){
        font = Font.latoRegular.withSize(14)
        numberOfLines = 0
    }
}
