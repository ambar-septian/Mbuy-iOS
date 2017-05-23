//
//  UIImageView+Extension.swift
//  MCommerce
//
//  Created by Ambar Septian on 5/22/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit

extension UIImageView {
    func setImage(urlString: String, completion: (() -> Void)? = nil) {
        guard let url = URL(string: urlString) else { return }
        
        self.af_setImage(withURL: url, placeholderImage: nil, filter: nil, progress: nil, imageTransition:.crossDissolve(0.5), runImageTransitionIfCached: false) { (result) in
            guard result.value != nil else { return }
            
            guard completion != nil else { return }
            completion!()
        }
    }
}
