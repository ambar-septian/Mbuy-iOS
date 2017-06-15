//
//  RoundedView.swift
//  MCommerce
//
//  Created by Ambar Septian on 6/14/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit
import QuartzCore

class RoundedView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        let contentRect = rect.insetBy(dx: 5, dy: 2)
        
        let roundedPath = UIBezierPath(roundedRect: contentRect, cornerRadius: Constants.cornerRadius)
        context?.setFillColor(Color.white.cgColor)
        context?.setShadow(offset: CGSize(width:0, height:2), blur: 5, color: Color.lightGrayTableCell.cgColor)
        roundedPath.fill()
        
        roundedPath.addClip()
        context?.setStrokeColor(Color.white.withAlphaComponent(0.6).cgColor)
        context?.setBlendMode(.overlay)
        
        let startPoint = CGPoint(x:contentRect.minX, y:contentRect.minY + 0.5)
        let endPoint = CGPoint(x:contentRect.maxX, y:contentRect.minY + 0.5)
        context?.move(to: startPoint)
        context?.addLine(to: endPoint)
        context?.strokePath()
    }
}

extension RoundedView {
    func setupView(){
        backgroundColor = .clear
    }
}

