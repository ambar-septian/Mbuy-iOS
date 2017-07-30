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
        return subTotal + profile.deliveryCost
    }
    
    var formattedTotal:String {
        return total.formattedPrice
    }
    
    var key: String
    
    var ref: FIRDatabaseReference?
    
    var orderNumber: Int
    
    static let jsonKeys:(profile:String, carts:String, orderNumber: String, histories: String) =
        (profile: "profile", carts:"carts", orderNumber: "orderNumber", histories: "histories")

    
    
    init(profile:OrderProfile, carts: [Cart] = [Cart](), key:String = "", orderNumber: Int = 0, ref: FIRDatabaseReference?){
        self.profile = profile
        self.carts = carts
        self.key = key
        self.orderNumber = orderNumber
        self.ref = ref
    }
    
    required init(snapshot: FIRDataSnapshot,profile: OrderProfile, carts: [Cart]) {
        self.key = snapshot.key
        let jsonKeys = Order.jsonKeys
        let value = snapshot.value as? [String:AnyObject]
        ref = snapshot.ref
        
        self.carts = carts
        self.profile = profile
        self.orderNumber = value?[jsonKeys.orderNumber] as? Int ?? 0
    }
    
}
