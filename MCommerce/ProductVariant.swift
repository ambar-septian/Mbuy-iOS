//
//  ProductVariant.swift
//  MCommerce
//
//  Created by Ambar Septian on 6/28/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import Foundation

class ProductVariant {
    var stock: Int
    var name:String
    var isSelected: Bool = false

    static let jsonKeys:(variantName:String, stock:String) =
        (variantName:"variantName", stock:"stock")
    
    init(name:String, stock:Int) {
        self.name = name
        self.stock = stock
    }
    
    init(object: [String: AnyObject]) {
        let jsonKeys = ProductVariant.jsonKeys
        self.name = object[jsonKeys.variantName] as? String  ?? ""
        self.stock = object[jsonKeys.stock] as? Int  ?? 0
        
    }
}
