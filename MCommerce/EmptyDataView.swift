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
            let image = icon.image(ofSize: self.bounds.size, color: Color.darkCream)
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
        label.font = Font.latoRegular.withSize(18)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = Color.lightGray
        
        return label
    }()
    
    fileprivate lazy var detailLabel:UILabel = {
        let label = UILabel()
        label.font = Font.latoRegular
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
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviews()
    }
}

extension EmptyDataView {
    func toggleHide(willHide isHidden:Bool){
        guard self.isHidden != isHidden else { return }
        
        let alpha:CGFloat = isHidden ? 0 : 1
        UIView.animate(withDuration: 0.3, animations: { 
            self.alpha = alpha
        }) { (completed) in
            guard completed else { return }
            self.isHidden = isHidden
        }
    }
}

extension EmptyDataView: BaseViewProtocol {
    func setupSubviews() {
        backgroundColor = Color.cream
        
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(detailLabel)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        imageView.widthAnchor == self.widthAnchor * 0.4
        imageView.heightAnchor == imageView.widthAnchor
        imageView.topAnchor == self.topAnchor + 20
        imageView.centerXAnchor == self.centerXAnchor
        
        titleLabel.leadingAnchor == self.leadingAnchor + 40
        titleLabel.trailingAnchor == self.trailingAnchor - 40
        titleLabel.topAnchor == imageView.bottomAnchor + 20
        detailLabel.centerXAnchor == imageView.centerXAnchor
        detailLabel.topAnchor == titleLabel.bottomAnchor + 10
    }
}
