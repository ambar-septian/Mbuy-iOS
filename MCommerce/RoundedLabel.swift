//
//  RoundedLabel.swift
//  MCommerce
//
//  Created by Ambar Septian on 5/15/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit

class RoundedLabel: UILabel, RoundedBorderProtocol {
    var borderColor: UIColor = UIColor.clear
    var borderWidth: CGFloat = 0
    
    var mainColor: UIColor? {
        didSet {
            backgroundColor = mainColor
        }
    }
    var shadeColor: UIColor {
        return mainColor?.withAlphaComponent(0.5) ?? UIColor.clear
    }
    
    override func drawText(in rect: CGRect) {
        let inset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, inset))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLabel()
    }
    
    
    init(text:String, color: UIColor){
        super.init(frame: CGRect.zero)
        self.text = text
        backgroundColor = color
        mainColor = color
        sizeToFit()
        
        setupLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sizeToFit()
        
        setupLabel()
    }
    
    func setupLabel(){
        font = Font.latoRegular.withSize(12)
        numberOfLines = 0
        textColor = Color.white
        clipsToBounds = true
        setRoundedLayer()
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        setRoundedLayer()
    }
    
    
 
}
