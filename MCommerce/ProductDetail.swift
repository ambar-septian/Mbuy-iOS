//
//  ProductDescription.swift
//  MCommerce
//
//  Created by Ambar Septian on 6/13/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import Foundation

class ProductDetail {
    var field: String
    var value:String
    
    init(field:String, value:String){
        self.field = field
        self.value = value
    }
    
    static let jsonKeys:(field:String, value:String) =
        (field:"field", value:"value")
    
    
    init(object: [String: AnyObject]) {
        let jsonKeys = ProductDetail.jsonKeys
        self.field = object[jsonKeys.field] as? String ?? ""
        self.value = object[jsonKeys.value] as? String ?? ""
    }
}
