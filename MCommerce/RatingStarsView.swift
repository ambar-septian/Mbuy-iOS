//
//  RatingStarsView.swift
//  MCommerce
//
//  Created by Ambar Septian on 5/9/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit
class RatingStarsView: UIView {
    
    // MARK: Properties
    var numberOfStars: Int = 0 {
        didSet {
            self.createStarsView()
            self.layoutSubviews()
        }
    }
    
    private var starImageView = [UIImageView]()
    
    var size = CGSize(width: 15, height: 15) {
        didSet {
            sizeStarChanged()
        }
    }
    
    private var paddingButton: Int
    
    private let countStars = 5
    
    let kMaxRatingStars:Int = 10
    
    // MARK: Initialization
    
    override init(frame: CGRect) {
        self.paddingButton = Int(self.size.width / 2)
        super.init(frame: frame)
        
    }
    
    convenience init(frame: CGRect, numberOfStars: Int) {
        self.init(frame: frame)
        self.numberOfStars = numberOfStars
        self.paddingButton = Int(self.size.width / 2)
        //        self.createStarsView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.paddingButton = Int(self.size.width / 2)
        super.init(coder: aDecoder)
        //        self.createStarsView()
        
    }
    
    
    func changeNumberStars(numberOfStars: Int) {
        self.numberOfStars = numberOfStars
        self.createStarsView()
        //        self.layoutSubviews()
    }
    
    // MARK: Override Function
    
    override var intrinsicContentSize: CGSize {
        let height = Int(frame.size.height)
        let width = (Int(size.width) + paddingButton) * countStars
        return CGSize(width: width, height: height)
    }
    
    
    
    // MARK: Function
    
    private func createStarsView(){
        starImageView.removeAll()
        self.subviews.forEach({ $0.removeFromSuperview() })
        
        let sub = Double(kMaxRatingStars - numberOfStars)
        let calc = Double(countStars) - (sub / 2)
        
        for index in 1...self.countStars {
            let starImage = UIImageView(frame: CGRect(x: 0, y: 0, width: self.size.width , height: self.size.height))
            
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
        var ratingFrame = CGRect(x: 0, y: -(self.size.height * 2), width: size.width, height: size.height)
        for (index, _) in starImageView.enumerated() {
            ratingFrame.origin.x = CGFloat(index * (Int(size.width) + paddingButton))
            starImageView[index].frame = ratingFrame
        }
    }
    
    
    
    private func sizeStarChanged() {
        starImageView.removeAll()
        self.createStarsView()
        self.layoutSubviews()
        
    }
    
    
    
    func ratingButtonTapped(sender: AnyObject) {
        
    }
    
}
