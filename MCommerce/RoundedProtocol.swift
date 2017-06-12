//
//  RoundedBorderProtocol.swift
//  MCommerce
//
//  Created by Ambar Septian on 5/9/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit

protocol RoundedBorderProtocol {
    var borderColor: UIColor { get set }
    var borderWidth: CGFloat { get set }
    var mainColor: UIColor? { get set }
    var shadeColor: UIColor { get }
}

extension RoundedBorderProtocol where Self: UIView {
    func setRoundedLayer(){
        backgroundColor = mainColor
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        layer.cornerRadius = Constants.cornerRadius
        layer.masksToBounds = true
    }
}

protocol RoundedShadowProtocol {}

extension RoundedShadowProtocol where Self: UIView{
    func setRoundedLayer(view: UIView){
        let shadowLayer = CALayer()
        shadowLayer.frame = view.bounds
        shadowLayer.backgroundColor = Color.clear.cgColor
        shadowLayer.shadowColor = Color.grayShadow.cgColor
        shadowLayer.shadowOffset = CGSize(width: 0, height: 2)
        shadowLayer.shadowRadius = 8
//        layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: 8).cgPath
        shadowLayer.shouldRasterize = true
        shadowLayer.rasterizationScale = UIScreen.main.scale
        
    
        layer.cornerRadius = Constants.cornerRadius
//        layer.masksToBounds = true
//        layer.backgroundColor = Color.white.cgColor
        view.layer.insertSublayer(shadowLayer, at: 0)
        
//        clipsToBounds = true
    }
}
