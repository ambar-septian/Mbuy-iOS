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
    
    fileprivate var starImageView = [UIImageView]()
    
    var size = CGSize(width: 15, height: 15) {
        didSet {
            sizeStarChanged()
        }
    }
    
    fileprivate var paddingButton: CGFloat {
        return self.size.width / CGFloat(countStars)
    }
    
    fileprivate var countStars = 5
    
    fileprivate let kMaxRatingStars:Int = 10
    
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
    
    override var intrinsicContentSize: CGSize {
        let height = frame.size.height
        let width = (size.width + paddingButton) * CGFloat(numberOfStars)
        return CGSize(width: width, height: height)
    }

    
    func setupView(){
        
        backgroundColor = .clear
    }
}

extension RatingStarsView {
    // MARK: Function
    
    fileprivate func createStarsView(){
        starImageView.removeAll()
        self.subviews.forEach({ $0.removeFromSuperview() })
        
        let sub = Double(kMaxRatingStars - countStars)
        let calc = Double(numberOfStars) - (sub / 2)
        
        let size = self.size.width / 2
        for index in 1...self.countStars {
            let starImage = UIImageView(frame: CGRect(x: 0, y: self.size.height, width: size, height: size))
            
            if index <= Int(floor(calc)) {
                starImage.image = UIImage(named: "full-star")
            } else if (index == Int(ceil(calc)) && (numberOfStars % 2 == 1)) {
                starImage.image = UIImage(named: "half-star")
            } else {
                starImage.image = UIImage(named: "empty-star")
            }
            
            
            starImageView += [starImage]
            addSubview(starImage)
        }
        
        print(self.frame.origin.y)
        var ratingFrame = CGRect(x: 0, y: 0, width: size, height: size)
        for (index, _) in starImageView.enumerated() {
            ratingFrame.origin.x = CGFloat(index) * (size + paddingButton)
            starImageView[index].frame = ratingFrame
        }
    }
    
    
    
    fileprivate func sizeStarChanged() {
        starImageView.removeAll()
        self.createStarsView()
        self.layoutSubviews()
        
    }
    
    
    
    fileprivate func ratingButtonTapped(sender: AnyObject) {
        
    }
}
