//
//  BasicButton.swift
//  MCommerce
//
//  Created by Ambar Septian on 5/10/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit

class BasicButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    convenience init(title:String, color: UIColor = Color.orange, fontSize: CGFloat = 14) {
        self.init(frame: CGRect.zero)
        setTitle(title, for: .normal)
        setTitleColor(color, for: .normal)
        titleLabel?.font = Font.latoBold.withSize(fontSize)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
        
    }
}

extension BasicButton {
    fileprivate func setupButton(){
        setTitleColor(Color.orange, for: .normal)
        let pointSize = titleLabel?.font.pointSize ?? Font.defaultSize
        titleLabel?.font = Font.latoBold.withSize(pointSize)
    }
}
