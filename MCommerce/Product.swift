//
//  Product.swift
//  MCommerce
//
//  Created by Ambar Septian on 5/10/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit

class Product {
    var productID: String
    var name:String
    var category: Category
    var imageURL: String
    var stock: Int
    var description: String
    var price: Double
    var createdDate: Date
    var rating:Int = 0
    
    var formattedPrice: String {
        return price.formattedPrice
       
    }
    
    var formattedStock: String {
        let stockDesc = "stock".localize
        return stockDesc + " : " + String(stock)
    }
    
    var imageSize: CGSize?
    
    public init(productID: String, name: String, category: Category, imageURL: String, stock: Int, description: String, price: Double, createdDate: Date) {
        self.productID = productID
        self.name = name
        self.category = category
        self.imageURL = imageURL
        self.stock = stock
        self.description = description
        self.price = price
        self.createdDate = createdDate
    }
    
}
