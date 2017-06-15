//
//  RoundedStepper.swift
//  MCommerce
//
//  Created by Ambar Septian on 6/14/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit

class RoundedStepper: UIView {
    fileprivate lazy var incrementButton: UIButton = {
        let button = UIButton()
        button.setTitle("+", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.frame.size = CGSize(width: self.frame.width / 3, height: self.frame.height)
        button.frame.origin.y = self.bounds.origin.y
        button.frame.origin.x = (self.bounds.width * 0.7)
        button.titleLabel?.numberOfLines = 1
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.addTarget(self, action: #selector(self.incrementCounter(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    fileprivate lazy var decrementButton:UIButton = {
        let button = UIButton()
        button.setTitle("-", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.frame.size = CGSize(width: self.frame.width / 3, height: self.frame.height)
        button.frame.origin.x = (self.bounds.width * 0.3) - (button.frame.size.width)
        button.frame.origin.y = self.bounds.origin.y
        button.titleLabel?.numberOfLines = 1
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.addTarget(self, action: #selector(self.decrementCounter(sender:)), for: .touchUpInside)
        
        return button
        
    }()
    
    fileprivate lazy var counterView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.frame.size = CGSize(width: self.bounds.width / 3, height: self.bounds.height)
        view.center.x = self.center.x
        view.frame.origin.y = self.frame.origin.y
        return view
    }()
    
    fileprivate lazy var counterLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textAlignment = .center
        label.frame.size = CGSize(width:self.bounds.size.width / 3, height: self.bounds.size.height)
        label.center = self.center
        label.center.x -= label.frame.size.width
        label.font = UIFont.systemFont(ofSize: 72)
        label.textColor = .red
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    var counter: Int  {
        get {
            return Int(counterLabel.text ?? "0") ?? 0
        } set {
            counterLabel.text = String(newValue)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup(){
        addSubview(counterView)
        addSubview(incrementButton)
        addSubview(decrementButton)
        counterView.addSubview(counterLabel)
        
        backgroundColor = Color.orange
        layer.cornerRadius = 8
    }
    
    func incrementCounter(sender: UIButton) {
        guard counter >= 0 else { return }
        counter += 1
    }
    
    func decrementCounter(sender: UIButton) {
        guard counter >= 1 else { return }
        counter -= 1
    }
}
