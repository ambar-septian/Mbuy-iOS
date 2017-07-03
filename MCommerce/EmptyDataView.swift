//
//  EmptyDataView.swift
//  MCommerce
//
//  Created by Ambar Septian on 7/3/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit
import Iconic
import Anchorage

class EmptyDataView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var iconImage: FontAwesomeIcon? {
        didSet {
            guard let icon = iconImage else { return }
            let image = icon.image(ofSize: self.bounds.size, color: Color.orange)
            imageView.image = image
        }
    }
    
    var image: UIImage? {
        didSet {
            guard let wImage = image else { return }
            imageView.image = wImage
        }

    }
    
    var title:String? {
        didSet {
            guard let wTitle = title else { return }
            titleLabel.text = wTitle
        }
    }
    
    var detail:String? {
        didSet {
            guard let wDetail = detail else { return }
            titleLabel.text = wDetail
        }
    }

    
    fileprivate lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Font.latoBold
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = Color.orange
        
        return label
    }()
    
    fileprivate lazy var detailLabel:UILabel = {
        let label = UILabel()
        label.font = Font.latoRegular.withSize(14)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = Color.lightGray

        
        return label
    }()
    
    fileprivate lazy var stackView:UIStackView = {
        let stackView = UIStackView(frame: self.bounds)
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
}

extension EmptyDataView {
    fileprivate func setupView(){
        backgroundColor = .clear
        addSubview(stackView)
        stackView.edgeAnchors == self.edgeAnchors
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(detailLabel)
    }
}
