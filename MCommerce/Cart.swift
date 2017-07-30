//
//  Cart.swift
//  MCommerce
//
//  Created by Ambar Septian on 6/21/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Cart: FirebaseProtocol {
    var cartID: String {
        return key
    }
    
    var product: Product
    var price:Double
    var formattedPrice: String {
        return price.formattedPrice
    }
    var createdDate: Date
    var quantity: Int
    var variant: ProductVariant?
    
    var key: String
    var ref: FIRDatabaseReference?
    
    
    static let jsonKeys:(product:String, price:String, createdDate: String, quantity : String, variant:String) =
        (product:"product", price:"price", createdDate: "createdDate", quantity : "quantity", variant: "variant")
    
    
    init(product:Product, price:Double, quantity:Int, createdDate: Date = Date(), key:String = "") {
        self.product = product
        self.price = price
        self.createdDate = createdDate
        self.quantity = quantity
        self.key = key
    }
    
    required init(snapshot: FIRDataSnapshot) {
        self.key = snapshot.key
        let jsonKeys = Cart.jsonKeys
        
        let snapshotValue = snapshot.value as! [String: AnyObject]
        self.product  = snapshotValue[jsonKeys.product] as! Product
        self.price  = snapshotValue[jsonKeys.price] as? Double ?? 0
        self.createdDate = snapshotValue[jsonKeys.createdDate] as? Date ?? Date()
        self.quantity = snapshotValue[jsonKeys.quantity] as? Int ?? 0
        ref = snapshot.ref
    }
    
    init(product:Product, snapshot: FIRDataSnapshot) {
        self.key = snapshot.key
        let jsonKeys = Cart.jsonKeys
        ref = snapshot.ref
        
        let snapshotValue = snapshot.value as! [String: AnyObject]
        self.product  = product
        self.price  = snapshotValue[jsonKeys.price] as? Double ?? 0
        self.createdDate = snapshotValue[jsonKeys.createdDate] as? Date ?? Date()
        self.quantity = snapshotValue[jsonKeys.quantity] as? Int ?? 0
        guard let variantName = snapshotValue[jsonKeys.variant] as? String else { return }
        
        if let productVariant = product.variants.filter({ $0.name == variantName }).first {
             self.variant = productVariant
        } else {
            let productVariant = ProductVariant(name: variantName, stock: 0)
            self.variant = productVariant
        }
       
       
    }
    
    init(dictionary: [String: Any], product: Product, index:Int) {
        let jsonKeys = Cart.jsonKeys
        self.price  = dictionary[jsonKeys.price] as? Double ?? 0
        self.createdDate = dictionary[jsonKeys.createdDate] as? Date ?? Date()
        self.quantity = dictionary[jsonKeys.quantity] as? Int ?? 0
        self.key = String(index)
        self.product = product
        
        guard let variantName = dictionary[jsonKeys.variant] as? String else { return }
        self.variant = product.variants.filter({ $0.name == variantName }).first
        
    }
    
}
