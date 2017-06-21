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
    var lastUpdateDate: Date? {
        return histories.last?.date
    }
    var lastStatus: OrderStatus? {
        return histories.last?.status
    }
    var histories = [OrderHistory]()
    
    init(orderID:String){
        self.orderID = orderID
    }
    
//    var firstName:String
//    var lastName:String
    
    
}
