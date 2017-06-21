//
//  String+Extension.swift
//  MCommerce
//
//  Created by Ambar Septian on 5/9/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import Foundation

extension String {
    var localize: String {
        return Localize.shared.bundle.localizedString(forKey: self, value: "", table: nil)
    }
    
    static func random(length: Int = 5, numberOnly:Bool = false) -> String {
        let base = numberOnly ? "0123456789":"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""
        
        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.characters.count))
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        return randomString
    }
    
    
}
