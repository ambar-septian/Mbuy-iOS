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
    
}
