//
//  UIImageView+Extension.swift
//  MCommerce
//
//  Created by Ambar Septian on 5/22/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit

extension UIImageView {
    func setImage(urlString: String, completion: ((_ image:UIImage) -> Void)? = nil) {
        guard let url = URL(string: urlString) else { return }
        
        self.af_setImage(withURL: url, placeholderImage: nil, filter: nil, progress: nil, imageTransition:.crossDissolve(0.5), runImageTransitionIfCached: false) { (result) in
    
            guard let wCompletion = completion else { return }
            guard let image = result.value  else { return }
            
            wCompletion(image)
        }
    }
    
    func circleImageView(){
        let minSize = min(self.bounds.width, self.bounds.height)
        let radius = minSize / 2
        layer.cornerRadius = radius
        layer.masksToBounds = true
        clipsToBounds = true
    }
}
