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
typealias cartsCompletion = ((_ carts: [Cart]) -> Void)

class CartController {
    fileprivate let ref = FIRDatabase.database().reference(withPath: "carts")
    fileprivate let productRef = FIRDatabase.database().reference(withPath: "products")
    fileprivate let user = User.shared
    
    fileprivate var cartListRef: FIRDatabaseReference?
    fileprivate var cartListHander: UInt?
    
    fileprivate let cartKey = Cart.jsonKeys
    
    func addToCart(product:Product, quantity: Int, completion: @escaping finishCompletion){
        
        let cartRef = ref.child(user.uid)
        cartRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if !(snapshot.exists()) {
                self.ref.setValue(self.user.uid)
            }
            let cartKey = self.cartKey
            let productRef = cartRef.child("\(product.productID)")
            self.isProductExist(product: product, cartRef: productRef, completion: { (isExist, previousQuantity) in
                if isExist {
                    let newQuantity = quantity + previousQuantity
                    productRef.child(self.cartKey.quantity).setValue(newQuantity)
                } else {
                    
                    let cart = [cartKey.price: product.price, cartKey.createdDate : Date().timeIntervalSince1970, cartKey.quantity: quantity, cartKey.variant : product.selectedVariant.name] as [String : Any]
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
                
                guard let variant = value["variant"] as? String else {
                    completion(false, 0)
                    return
                }
                
                guard variant == product.selectedVariant.name else {
                    completion(false, 0)
                    return
                }
                
                completion(true, value[Cart.jsonKeys.quantity] as? Int ?? 0)
            } else {
                completion(false, 0)
            }
        }) { (error) in
            completion(false, 0)
            print(error.localizedDescription)
        }
    }
    
    func getListCarts(completion: @escaping cartsCompletion){
        cartListRef = ref.child(user.uid)
        cartListHander = cartListRef?.observe(.value, with: { (snapshots) in
            var carts = [Cart]()
            guard snapshots.children.allObjects.count > 0 else {
                completion(carts)
                return
            }
            
            for snapshot in snapshots.children {
                guard let wSnapshot = snapshot as? FIRDataSnapshot else { continue }
                let productID = wSnapshot.key
            
                self.productRef.child(productID).observeSingleEvent(of:.value, with: { (productSnapshot) in
                    guard productSnapshot.value != nil else {
                        completion(carts)
                        return
                    }
                    let product = Product(snapshot: productSnapshot)
                  
                    let cart = Cart(product: product, snapshot: wSnapshot)
                    carts.append(cart)
                    
                    completion(carts)
                }) { (error) in
                    print(error.localizedDescription)
                    completion(carts)
                    
                }
            }
        })
    }
    
    func removeHandlerCartList(){
        guard let handler = cartListHander else { return }
        cartListRef?.removeObserver(withHandle: handler)
    }
    
    func deleteCart(cart: Cart) {
        cart.ref?.removeValue()
    }
    
    func deleteAllCarts(){
        ref.child(user.uid).removeValue()
    }
    
    func updateCartList(cart: Cart, quantity: Int){
        cart.ref?.child(Cart.jsonKeys.quantity).runTransactionBlock({ (data) -> FIRTransactionResult in
            data.value = quantity
            return FIRTransactionResult.success(withValue: data)
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
