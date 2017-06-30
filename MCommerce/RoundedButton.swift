//
//  RoundedButton.swift
//  MCommerce
//
//  Created by Ambar Septian on 5/9/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit

class RoundedButton: UIButton, RoundedBorderProtocol {

   
    var borderColor: UIColor = UIColor.white {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    
    var borderWidth: CGFloat = 2 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    var shadeColor: UIColor {
        if let backgroundColor = self.backgroundColor {
            return backgroundColor.withAlphaComponent(0.7)
        } else {
            return borderColor.withAlphaComponent(0.7)
        }
    }
    
    var mainColor:UIColor? = Color.clear {
        didSet {
            backgroundColor = mainColor
        }
    }
    
    var title:String? {
        didSet {
            setTitle(title, for: .normal)
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    init(backgroundColor:UIColor, borderColor:UIColor, borderWidth:CGFloat) {
        super.init(frame: CGRect.zero)
        self.mainColor = backgroundColor
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        
        setupButton()
    }
    
    
    func setupButton(){
        setRoundedLayer()
        layer.cornerRadius = bounds.width / bounds.height * 3
        titleLabel?.font = Font.latoBold.withSize(17)
        setTitleColor(UIColor.white, for: .normal)
    }
    
    override var isSelected: Bool {
        didSet {
            if isHighlighted {
                backgroundColor = shadeColor
            } else {
                backgroundColor = mainColor
            }
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                backgroundColor = shadeColor
            } else {
                backgroundColor = mainColor
            }
        }
    }
    
}
