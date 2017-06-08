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
        let shadowView = UIView(frame: view.bounds)
        shadowView.backgroundColor = .clear
        shadowView.layer.shadowColor = Color.grayShadow.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 2)
        shadowView.layer.shadowRadius = 4
//        layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: 8).cgPath
        shadowView.layer.shouldRasterize = true
        shadowView.layer.rasterizationScale = UIScreen.main.scale
        
    
        layer.cornerRadius = Constants.cornerRadius
        layer.masksToBounds = true
//        layer.backgroundColor = Color.white.cgColor
        view.insertSubview(shadowView, at: 0)
        
//        clipsToBounds = true
    }
}
