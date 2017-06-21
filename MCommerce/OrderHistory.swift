//
//  OrderHistory.swift
//  MCommerce
//
//  Created by Ambar Septian on 6/21/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import Foundation

class OrderHistory {
    var date: Date
    var status: OrderStatus
    
    var statusDescription: String {
        return status.rawValue.localize
    }
    
    init(date: Date, status: OrderStatus) {
        self.date = date
        self.status = status
    }
}

enum OrderStatus: String {
    case onDelivery = "onDelivery"
    case complete = "complete"
    case waitingPayment = "waitingPayment"
    case cancel = "cancel"
    
}
