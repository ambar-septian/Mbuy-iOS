//
//  Cart.swift
//  MCommerce
//
//  Created by Ambar Septian on 6/21/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import Foundation

class Cart {
    var cartID: String
    var product: Product
    var price:Double
    var formattedPrice: String {
        return price.formattedPrice
    }
    var createdDate: Date
    var quantity: Int
    
    init(product:Product, price:Double, quantity:Int) {
        self.cartID = String.random()
        self.product = product
        self.price = price
        self.createdDate = Date()
        self.quantity = quantity
    }
    
}
