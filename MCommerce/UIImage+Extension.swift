//
//  UIImage+Extension.swift
//  MCommerce
//
//  Created by Ambar Septian on 5/16/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit
import CoreImage
import AlamofireImage

extension UIImage {
    
    convenience init?(view: UIView){
        UIGraphicsBeginImageContextWithOptions(view.frame.size, true, 0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        view.layer.render(in: context)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        
        UIGraphicsEndImageContext()
        guard let cgImage = image.cgImage else { return nil }
        
        self.init(cgImage: cgImage)
        
        
    }
    
    convenience init?(color: UIColor) {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        context.setFillColor(color.cgColor)
        context.fill(rect)
        
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        
        UIGraphicsEndImageContext()
        
        guard let cgImage = image.cgImage else { return nil }
        
        self.init(cgImage: cgImage)
    }
}
