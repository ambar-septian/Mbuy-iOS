//
//  BackgroundLoginView.swift
//  MCommerce
//
//  Created by Ambar Septian on 5/15/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit

class BackgroundLoginView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupView(){
        guard !UIAccessibilityIsReduceMotionEnabled() else  {
            backgroundColor = Color.orange
            return
        }
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = #imageLiteral(resourceName: "background_login")
        imageView.frame = bounds
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(imageView)
        
        let view = UIView()
        view.backgroundColor = Color.orange.withAlphaComponent(0.7)
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
//
//        let blurEffect = UIBlurEffect(style: .regular)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = bounds
//        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
//        addSubview(blurEffectView)
    }

}
