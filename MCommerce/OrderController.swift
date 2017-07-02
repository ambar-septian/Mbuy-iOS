//
//  OrderController.swift
//  MCommerce
//
//  Created by Ambar Septian on 7/2/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import Foundation
import FirebaseDatabase

typealias newOrderNumberCompletion = ((_ orderNumber: String) -> Void)
typealias statusNumberCompletion = ((_ statusNumber: Int) -> Void)

class OrderController {
    fileprivate let orderRef = FIRDatabase.database().reference(withPath: "orders")
    fileprivate let cartRef = FIRDatabase.database().reference(withPath: "carts")
    fileprivate let productRef = FIRDatabase.database().reference(withPath: "products")
    
    fileprivate let user = User.shared
    
    
    func submitOrder(order: Order, completion: @escaping finishCompletion){
        let profile = order.profile
        guard let coordinate = profile.coordinate else {
            completion(false)
            return
        }
        let profileKey = OrderProfile.jsonKeys.self
        
        var orderDict = [profileKey.name : profile.name,
                     profileKey.email:profile.email,
                     profileKey.latitude: coordinate.latitude,
                     profileKey.longitude: coordinate.longitude,
                     profileKey.address : profile.address,
                     profileKey.phone : profile.phone,
                     profileKey.note : profile.note,
                     profileKey.deliveryCost : profile.deliveryCost] as [String : Any]
        
        
        getLastOrder { (orderNumber) in
            let orderKey = Order.jsonKeys.self
            let cartKey = Cart.jsonKeys.self
            let historyKey = OrderHistory.jsonKeys.self
            
            orderDict[orderKey.orderNumber] = orderNumber
            
            var carts = [[String:Any]]()
            for cart in order.carts {
                var dict = [String:Any]()
                dict[cartKey.product]  = cart.product.productID
                dict[cartKey.price] =  cart.product.price
                dict[cartKey.quantity] = cart.quantity
                guard let variant = cart.variant?.name else { continue }
                dict[cartKey.variant] = variant
                
                carts.append(dict)
            }
            
            orderDict[orderKey.carts] = carts
            
            var history = [String:Any]()
            history[historyKey.status] = OrderStatus.waitingPayment.rawValue
            history[historyKey.date] = Date().timeIntervalSince1970
            
            self.getLastStatusNumber(completion: { (statusNumber) in
                history[historyKey.sortNumber] = statusNumber
                orderDict[orderKey.histories] = history
                self.orderRef.childByAutoId().setValue(orderDict)
                completion(true)
            })
        }
        
    }
    
    fileprivate func getLastOrder(completion: @escaping newOrderNumberCompletion) {
        orderRef.observeSingleEvent(of: .value, with: { (snapshot) in
            completion(String(snapshot.childrenCount + 1))
        })
    }
    
    fileprivate func getLastStatusNumber(completion: @escaping statusNumberCompletion) {
        orderRef.observeSingleEvent(of: .value, with: { (snapshot) in
            completion(Int(snapshot.childrenCount) + 1)
        })
    }
}
