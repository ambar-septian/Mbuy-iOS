//
//  Order.swift
//  MCommerce
//
//  Created by Ambar Septian on 6/21/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import Foundation

class Order {
    var orderID: String
    var profile: OrderProfile
    var lastUpdateDate: Date? {
        return histories.last?.date
    }
    var lastStatus: OrderStatus? {
        return histories.last?.status
    }
    var histories = [OrderHistory]()
    var carts = [Cart]()
    
    var cartQuantity: Int {
        return carts.reduce(0, {$0 + $1.quantity })
    }
    
    var cartTotal: Double {
        return carts.reduce(0, {$0 + ($1.price) }) * Double(cartQuantity)
    }
    
    var cartFormattedPrice: String {
        return cartTotal.formattedPrice
    }
    
    
    init(orderID:String, profile:OrderProfile){
        self.orderID = orderID
        self.profile = profile
    }
    
}
