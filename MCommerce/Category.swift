//
//  Category.swift
//  MCommerce
//
//  Created by Ambar Septian on 5/10/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import Foundation

class Category {
    var categoryID: String
    var name: String
    var imageURL: String
    
    public init(categoryID: String, name: String, imageURL: String) {
        self.categoryID = categoryID
        self.name = name
        self.imageURL = imageURL
    }
}
