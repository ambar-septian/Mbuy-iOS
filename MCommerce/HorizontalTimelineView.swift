//
//  HorizontalTImelineView.swift
//  MCommerce
//
//  Created by Ambar Septian on 6/25/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit
import Anchorage

protocol HorizontalTimelineViewDelegate: class {
    func didActiveCircleViewMove(index:Int)
}
class HorizontalTimelineView: UIView {
    
    var stepCount =  3
    
    fileprivate var circleViews = [UIView]()
    
    lazy var activeCircleView: UIView = {
        let circleView = UIView()
        circleView.backgroundColor = Color.white
        circleView.layer.masksToBounds = true
        circleView.layer.borderColor = Color.orange.cgColor
        circleView.layer.borderWidth = 3
        
        return circleView
    }()
    
    fileprivate var spacing: CGFloat {
        return self.bounds.width / CGFloat(stepCount)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        circleViews.forEach({ $0.layer.cornerRadius = $0.bounds.width / 2})
        activeCircleView.layer.cornerRadius = activeCircleView.bounds.width / 2
    }
}

extension HorizontalTimelineView {
    fileprivate func setupView(){
        for i in 0 ..< stepCount {
            let circleView = UIView()
            circleView.tag = i
            circleView.backgroundColor = Color.white
            addSubview(circleView)
            
            
            circleView.centerYAnchor == self.centerYAnchor
            circleView.heightAnchor == self.heightAnchor * 0.5
            circleView.widthAnchor == circleView.heightAnchor
            
            if i == 0 {
                circleView.leadingAnchor == self.leadingAnchor
            } else {
                circleView.leadingAnchor == circleViews[i - 1].trailingAnchor + spacing
            }
            
            circleView.layer.borderColor = Color.green.cgColor
            circleView.layer.borderWidth = 2
            
            circleView.updateConstraints()
            circleView.layer.cornerRadius = circleView.bounds.width / 2
            circleView.layer.masksToBounds = true
            circleViews.append(circleView)
        }
        
        
        addSubview(activeCircleView)
        activeCircleView.centerXAnchor == circleViews[0].centerXAnchor
        activeCircleView.widthAnchor == self.heightAnchor * 0.7
        activeCircleView.heightAnchor == activeCircleView.widthAnchor
        activeCircleView.centerYAnchor == self.centerYAnchor
        
        let lineView = UIView()
        insertSubview(lineView, at: 0)
        
        lineView.backgroundColor = Color.green
        lineView.leadingAnchor == activeCircleView.leadingAnchor
        lineView.trailingAnchor == circleViews[stepCount - 1].trailingAnchor
        lineView.heightAnchor == self.heightAnchor * 0.1
        lineView.centerYAnchor == self.centerYAnchor
        
        
        backgroundColor = Color.clear
    }
    
    func moveActiveCircleView(index: Int){
        guard circleViews.count >= index  else { return }
        if index == 0 {
            activeCircleView.leadingAnchor == self.leadingAnchor
        } else {
            activeCircleView.centerXAnchor == circleViews[index - 1].centerXAnchor
        }
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.layoutIfNeeded()
        })
        
        
    }
}
