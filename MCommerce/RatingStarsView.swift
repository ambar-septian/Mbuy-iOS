//
//  RatingStarsView.swift
//  MCommerce
//
//  Created by Ambar Septian on 5/9/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit
import Iconic

class RatingStarsView: UIView {
    
    // MARK: Properties
    var numberOfStars: Int = 0 {
        didSet {
            self.createStarsView()
            self.layoutSubviews()
        }
    }
    
    fileprivate var starImageViews = [UIImageView]()
    
    
    fileprivate var countStars = 5
    
    fileprivate let kMaxRatingStars:Int = 10
    
    fileprivate lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.frame = self.bounds
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        return stackView
    }()
    
    // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    convenience init(frame: CGRect, numberOfStars: Int) {
        self.init(frame: frame)
        self.numberOfStars = numberOfStars
        setupView()
        //        self.createStarsView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
        //        self.createStarsView()
        
    }
    
    
    // MARK: Override Function
    
//    override var intrinsicContentSize: CGSize {
////        let height = frame.size.height
////        let width = (size.width + padding) * CGFloat(numberOfStars)
////        return CGSize(width: width, height: height)
//    }

    
    func setupView(){
        addSubview(stackView)
        backgroundColor = .clear
        clipsToBounds = true
    }
}

extension RatingStarsView {
    // MARK: Function
    
    fileprivate func createStarsView(){
        starImageViews.removeAll()
        self.stackView.subviews.forEach({ $0.removeFromSuperview() })
        
        let sub = Double(kMaxRatingStars - countStars)
        let calc = Double(numberOfStars) - (sub / 2)
        
        for index in 1...self.countStars {
            let starImage = UIImageView()
            starImage.contentMode = .scaleAspectFit
            
            if index <= Int(floor(calc)) {
                starImage.image = #imageLiteral(resourceName: "full-star")
            } else if (index == Int(ceil(calc)) && (numberOfStars % 2 == 1)) {
                starImage.image = #imageLiteral(resourceName: "half-star")
            } else {
                starImage.image = #imageLiteral(resourceName: "empty-star")
            }
            
            
            starImageViews += [starImage]
            stackView.addArrangedSubview(starImage)
        }
    }
    
    
    
    fileprivate func ratingButtonTapped(sender: AnyObject) {
        
    }
}
