//
//  RoundedStepper.swift
//  MCommerce
//
//  Created by Ambar Septian on 6/14/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit
import Anchorage

protocol RoundedStepperDelegate: class {
    func stepperValueDidUpdate(value:Int)
}

class RoundedStepper: UIView {
    fileprivate lazy var incrementButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("+", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.frame.size = CGSize(width: self.bounds.width * 0.25, height: self.frame.height)
        button.frame.origin.y = self.bounds.origin.y
        button.frame.origin.x = self.bounds.width  - button.frame.width
        button.titleLabel?.numberOfLines = 1
        button.titleLabel?.font = Font.latoBold.withSize(self.fontSize)
        button.addTarget(self, action: #selector(self.incrementCounter(sender:)), for: .touchUpInside)
        button.backgroundColor = Color.orange
        button.layer.cornerRadius = 8
        
        return button
    }()
    
    fileprivate lazy var decrementButton:UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("-", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.frame.size = CGSize(width: self.bounds.width *  0.25, height: self.frame.height)
        button.frame.origin.x = 0
        button.frame.origin.y = self.bounds.origin.y
        button.titleLabel?.numberOfLines = 1
        button.titleLabel?.font = Font.latoBold.withSize(self.fontSize)
        button.addTarget(self, action: #selector(self.decrementCounter(sender:)), for: .touchUpInside)
        button.backgroundColor = Color.orange
        button.layer.cornerRadius = 8
        
        return button
        
    }()
    
    fileprivate lazy var counterLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textAlignment = .center
        label.frame = self.bounds
        label.font = Font.latoBold.withSize(self.fontSize)
        label.textColor = Color.orange
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
    
    var fontSize: CGFloat {
        return max(self.bounds.width, self.bounds.height) / min(self.bounds.width, self.bounds.height) * 4
    }
    
    weak var delegate: RoundedStepperDelegate?
    
    var minimumValue = 1
    
    var stepper = 1
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup(){
        addSubview(counterLabel)
        addSubview(incrementButton)
        addSubview(decrementButton)
        
        counterLabel.edgeAnchors == self.edgeAnchors
        decrementButton.leadingAnchor == self.leadingAnchor
        decrementButton.verticalAnchors == self.verticalAnchors
        decrementButton.widthAnchor == self.widthAnchor * 0.25
        
        incrementButton.trailingAnchor == self.trailingAnchor
        incrementButton.verticalAnchors == self.verticalAnchors
        incrementButton.widthAnchor == self.widthAnchor * 0.25
        
    }

    
    func incrementCounter(sender: UIButton) {
        guard counter >= minimumValue else { return }
        counter += stepper
        delegate?.stepperValueDidUpdate(value: counter)
    }
    
    func decrementCounter(sender: UIButton) {
        guard counter > minimumValue else { return }
        counter -= stepper
        delegate?.stepperValueDidUpdate(value: counter)
       
    }
}
