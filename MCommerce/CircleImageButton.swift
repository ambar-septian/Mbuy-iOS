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
            backgroundColor = mainColor
        }
    }
    
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    
    override func updateConstraints() {
        super.updateConstraints()
        layer.cornerRadius = frame.width / 2
        layer.masksToBounds = true
        clipsToBounds = true
        
        backgroundColor = mainColor
        iconImageView.image = iconImage
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
        self.mainColor = backgroundColor
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
        addSubview(iconImageView)
        setTitle(nil, for: .normal)
    }
    
    func setupConstraints() {
        guard let imageSuperView = iconImageView.superview else { return }
        iconImageView.edgeAnchors == imageSuperView.edgeAnchors + 10
        updateConstraints()
    }
}
