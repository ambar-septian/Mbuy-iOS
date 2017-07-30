//
//  OrderController.swift
//  MCommerce
//
//  Created by Ambar Septian on 7/2/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import Foundation
import FirebaseDatabase

typealias newOrderNumberCompletion = ((_ orderNumber: Int) -> Void)
typealias statusNumberCompletion = ((_ statusNumber: Int) -> Void)
typealias finishWithOrderRefCompletion = ((_ orderID: FIRDatabaseReference?) -> Void)
typealias ordersCompletion = ((_ orders: [Order]) -> Void)

class OrderController {
    fileprivate lazy var orderRef: FIRDatabaseReference = {
        return FIRDatabase.database().reference(withPath: "orders").child(self.user.uid)
    }()
    
    fileprivate lazy var orderLastNumberRef: FIRDatabaseReference = {
        return FIRDatabase.database().reference(withPath: "orders").child("lastNumber")
    }()
    

    
    fileprivate let cartRef = FIRDatabase.database().reference(withPath: "carts")
    fileprivate let productRef = FIRDatabase.database().reference(withPath: "products")
    
    fileprivate var orderListRef: FIRDatabaseReference?
    fileprivate var orderListHander: UInt?
    
    fileprivate let user = User.shared
    
    
    func submitOrder(order: Order, completion: @escaping finishWithOrderRefCompletion){
        let profile = order.profile
        guard let coordinate = profile.coordinate else {
            completion(nil)
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
                orderDict[orderKey.histories] = [history]
                let newOrder = self.orderRef.childByAutoId()
                newOrder.setValue(orderDict)
                self.updateLastOrderNumber()
                
                completion(newOrder)
            })
        }
        
    }
    
    fileprivate func getLastOrder(completion: @escaping newOrderNumberCompletion) {
        orderLastNumberRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? Int ?? 0
            completion(value + 1)
        })
    }
    
    fileprivate func getLastStatusNumber(completion: @escaping statusNumberCompletion) {
        orderRef.observeSingleEvent(of: .value, with: { (snapshot) in
            completion(Int(snapshot.childrenCount))
        })
    }
    
    fileprivate func updateLastOrderNumber(){
        orderLastNumberRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? Int ?? 0
            self.orderLastNumberRef.setValue(value)
        })
    }
    
    func listOrders(completion: @escaping ordersCompletion){
        orderListRef = orderRef
        let orderKey = Order.jsonKeys.self
        
        orderListHander = orderListRef?.queryOrderedByKey().observe(.value, with: { (snapshots) in
            var orders = [Order]()
            guard snapshots.childrenCount > 0 else {
                completion(orders)
                return
            }
            
            for (index,snapshot) in snapshots.children.enumerated() {
                guard let wSnapshot = snapshot as? FIRDataSnapshot else { continue }
                guard let value = wSnapshot.value as? [String: Any] else { continue }
                guard let cartsDictionary = value[orderKey.carts] as? [[String: Any]] else { continue }
                guard let orderNumber = value[orderKey.orderNumber] as? Int else { continue }
                
                self.listCartsOfOrder(cartsDictionary: cartsDictionary, completion: { (carts) in
                    let profile = OrderProfile(snapshot: wSnapshot)
                    let order = Order(profile: profile, carts: carts, key: wSnapshot.key, orderNumber: orderNumber, ref: wSnapshot.ref)
                
                    if let historyDict = value[orderKey.histories] as? [[String: Any]] {
                        let histories = self.listHistoriesOfOrder(historiesDict: historyDict)
                        order.histories = histories
                    }
                    
                    orders.append(order)
                    
                    if (Int(snapshots.childrenCount) - 1 == index) {
                        orders.sort(by: { $0.orderNumber > $1.orderNumber })
                        completion(orders)
                    }
                })
            }
            
           
        })
    }
    
    fileprivate func listCartsOfOrder(cartsDictionary: [[String:Any]], completion: @escaping cartsCompletion){
        var carts = [Cart]()
        let cartKey = Cart.jsonKeys.self
    
        for (index,cartDictionary) in cartsDictionary.enumerated() {
            guard let productID = cartDictionary[cartKey.product] as? String else { continue }
            
            productRef.child(productID).observeSingleEvent(of: .value, with: { (dataSnapshot) in
                let product = Product(snapshot: dataSnapshot)
                let cart = Cart(dictionary: cartDictionary, product: product, index: index)
                carts.append(cart)
                
                if index == cartsDictionary.count - 1 {
                    completion(carts)

                }
            })
        }
        
        
    }
    
    fileprivate func listHistoriesOfOrder(historiesDict:  [[String:Any]]) -> [OrderHistory] {
        var histories = [OrderHistory]()
        for dict in historiesDict {
           let history = OrderHistory(dictionary: dict)
            histories.append(history)
        }
        
        return histories
    }
    
    func removeOrderListHandler(){
        guard let handler = orderListHander else { return }
        orderListRef?.removeObserver(withHandle: handler)
    }
    
    func cancelOrder(order: Order) {
        order.ref?.removeValue()
    }
    
    func postOrderConfirmation(ref:FIRDatabaseReference, accountName:String, accountNumber:String, transferAmount: Double ){
        let paymentDict: [String:Any] = ["accountName": accountName, "accountNumber": accountNumber, "transferAmount" : transferAmount]
        ref.child("payment").setValue(paymentDict)
        
        ref.child("histories").observeSingleEvent(of: .value, with: { (snapshot) in
            let lastNumber = Int(snapshot.childrenCount)
            let historyKey = OrderHistory.jsonKeys
            
            let historyDict = [historyKey.date : Date().timeIntervalSince1970, historyKey.sortNumber : lastNumber, historyKey.status: OrderStatus.validatingPayment.rawValue] as [String : Any]
            
            ref.child("histories/\(lastNumber)").updateChildValues(historyDict)
            
            let savedUserProfile = SavedOrderProfile.shared.self
            savedUserProfile.accountName = accountName
            savedUserProfile.accountNumber = accountNumber
            
        })
    }
    
    
    func postCompleteOrer(ref:FIRDatabaseReference){
        ref.child("histories").observeSingleEvent(of: .value, with: { (snapshot) in
            let lastNumber = Int(snapshot.childrenCount)
            let historyKey = OrderHistory.jsonKeys
            
            let historyDict = [historyKey.date : Date().timeIntervalSince1970, historyKey.sortNumber : lastNumber, historyKey.status: OrderStatus.completed.rawValue] as [String : Any]
            
            ref.child("histories/\(lastNumber)").updateChildValues(historyDict)
        })

    }
    
    func finishSubmitOrder(order: Order){
        // empty cart
        let cartController = CartController()
        cartController.deleteAllCarts()

        let savedUserProfile = SavedOrderProfile.shared.self
        let orderProfile = order.profile
        savedUserProfile.name = orderProfile.name
        savedUserProfile.email = orderProfile.email
        savedUserProfile.phone = orderProfile.phone
        
    }
  

    
}
