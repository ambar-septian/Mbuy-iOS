//
//  Order.swift
//  MCommerce
//
//  Created by Ambar Septian on 6/21/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Order: FirebaseProtocol {
    var orderID: String {
        return key
    }
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
    
    var subTotal: Double {
        return carts.reduce(0, {$0 + ($1.price) }) * Double(cartQuantity)
    }
    
    var formattedSubtotal: String {
        return subTotal.formattedPrice
    }
    
    
    var total:Double {
        return subTotal * profile.deliveryCost
    }
    
    var formattedTotal:String {
        return total.formattedPrice
    }
    
    var key: String
    
    var ref: FIRDatabaseReference?
    
    var orderNumber: String?
    
    static let jsonKeys:(profile:String, carts:String, orderNumber: String, carts:String, histories: String) =
        (profile: "profile", carts:"carts", orderNumber: "orderNumber", carts: "carts", histories: "histories")

    
    
    init(profile:OrderProfile, carts: [Cart] = [Cart](), key:String = ""){
        self.profile = profile
        self.carts = carts
        self.key = key
    }
    
    required init(snapshot: FIRDataSnapshot) {
        self.key = snapshot as! String
        self.profile = snapshot as! OrderProfile
        self.carts = snapshot as! [Cart]
    }
    
}
