//
//  CartController.swift
//  MCommerce
//
//  Created by Ambar Septian on 7/1/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import Foundation
import FirebaseDatabase

typealias isCartExistCompletion = ((_ isExist: Bool, _ previousQuantity:Int) -> Void)
class CartController {
    fileprivate let ref = FIRDatabase.database().reference(withPath: "carts")
    fileprivate let user = User.shared
    
    
    func addToCart(product:Product, quantity: Int, completion: @escaping finishCompletion){
        let cartRef = ref.child(user.uid)
        cartRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if !(snapshot.exists()) {
                self.ref.setValue(self.user.uid)
            }
            
            let productRef = cartRef.child("\(product.productID)")
            self.isProductExist(product: product, cartRef: productRef, completion: { (isExist, previousQuantity) in
                if isExist {
                    let newQuantity = quantity + previousQuantity
                    productRef.child("quantity").setValue(newQuantity)
                } else {
                    
                    let cart = ["price": product.price, "createdDate" : Date.timeIntervalSinceReferenceDate, "quantity": quantity] as [String : Any]
                    productRef.setValue(cart)
                }
            })
            
           
            completion(true)
            
        }) { (error) in
            print(error.localizedDescription)
            completion(false)
        }
        
    }
    
    func isProductExist(product: Product, cartRef: FIRDatabaseReference, completion: @escaping isCartExistCompletion){
        cartRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                guard let value = snapshot.value as? [String : Any] else {
                    completion(false, 0)
                    return
                }
                completion(true, value["quantity"] as? Int ?? 0)
            } else {
                completion(false, 0)
            }
        }) { (error) in
            completion(false, 0)
            print(error.localizedDescription)
        }
    }
    
    func getListCarts(){
        let cartRef = ref.child(user.uid)
        cartRef.observe(.value, with: { (snapshot) in
            
        })
    }
    
    
//    var cartID: String
//    var product: Product
//    var price:Double
//    var formattedPrice: String {
//        return price.formattedPrice
//    }
//    var createdDate: Date
//    var quantity: Int
}
