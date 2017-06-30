//
//  CircleImageButton.swift
//  MCommerce
//
//  Created by Ambar Septian on 5/15/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit
import Iconic
import Anchorage

class CircleImageButton: UIButton {

    var icon: FontAwesomeIcon? {
        didSet {
            iconImageView.image = iconImage
        }
    }
    
    var iconColor: UIColor = Color.white {
        didSet {
            iconImageView.image = iconImage
            
        }
    }
    
    var iconImage: UIImage {
        guard let wIcon = icon else { return UIImage() }
        return wIcon.image(ofSize: CGSize(width: 30, height:30), color: iconColor)
    }
    
    var mainColor: UIColor = UIColor.clear {
        didSet {
            circleView.backgroundColor = mainColor
        }
    }
    
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var shadowView: UIView = {
        let view = UIView(frame: self.bounds)
        view.layer.shadowColor = Color.grayShadow.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 8
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = UIScreen.main.scale
        view.layer.masksToBounds = true
        
        return view
    }()
    
    lazy var circleView: UIView = {
        let view = UIView(frame: self.bounds)
        view.backgroundColor = .clear
        view.layer.cornerRadius = self.bounds.width / 2
        view.layer.masksToBounds = true
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.isUserInteractionEnabled = false
        return view
    }()
    
    
    override func updateConstraints() {
        super.updateConstraints()
//        circleView.layer.cornerRadius = frame.width / 2
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        circleView.layer.cornerRadius = frame.width / 2
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    init(backgroundColor:UIColor, icon:FontAwesomeIcon) {
        super.init(frame: CGRect.zero)
        self.circleView.backgroundColor = backgroundColor
        self.icon = icon
        
        setupButton()
    }
    
    func setupButton(){
        setupSubviews()
        setupConstraints()
    }
    

}

extension CircleImageButton: BaseViewProtocol {
    func setupSubviews() {
        layer.shadowColor = Color.grayShadow.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 8
        layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.bounds.width / 2).cgPath
//        layer.shouldRasterize = true
//        layer.rasterizationScale = UIScreen.main.scale
        layer.masksToBounds = true
        
        addSubview(circleView)
        circleView.addSubview(iconImageView)
        setTitle(nil, for: .normal)
    }
    
    func setupConstraints() {
        guard let imageSuperView = iconImageView.superview else { return }
        iconImageView.edgeAnchors == imageSuperView.edgeAnchors + 10
        updateConstraints()
    }
}
