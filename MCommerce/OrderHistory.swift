//
//  OrderHistory.swift
//  MCommerce
//
//  Created by Ambar Septian on 6/21/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import Foundation
import UIKit

class OrderHistory {
    var date: Date
    var status: OrderStatus
    
    var statusDescription: String {
        return status.rawValue.localize
    }
    
    var sortNumber:Int
    
    init(date: Date, status: OrderStatus, sortNumber:Int) {
        self.date = date
        self.status = status
        self.sortNumber = sortNumber
    }
    
    static let jsonKeys:(date:String, status:String, sortNumber:String) =
        (date:"date", status:"status", sortNumber:"sortNumber")
}

enum OrderStatus: String {
    case onDelivery = "onDelivery"
    case complete = "complete"
    case waitingPayment = "waitingPayment"
    case cancel = "cancel"
    
    var color:UIColor {
        switch self {
        case .waitingPayment:
            return Color.darkGray
        case .complete:
            return Color.green
        case .onDelivery:
            return Color.orange
        case .cancel:
            return Color.red
        }
    }
    
}
