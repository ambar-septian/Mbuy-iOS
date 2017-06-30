//
//  Product.swift
//  MCommerce
//
//  Created by Ambar Septian on 5/10/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit
import FirebaseDatabase

class Product: FirebaseProtocol {
    var productID: String {
        return key
    }
    var name:String
    
    var category: Category?
    
    var stock: Int {
        return variants.reduce(0, { $0 + $1.stock })
    }
    
    var description: String
    var price: Double
    var createdDate: Date
    var rating:Int = 0
    var details = [ProductDetail]()
    
    var formattedPrice: String {
        return price.formattedPrice
    }
    
    var formattedCreatedDate: String {
        return createdDate.formattedDate(dateFormat: .dateLong)
    }
    
    var imageURLs = [String]()
    
    var coverURL: String {
        return imageURLs.first ?? ""
    }
    
    var formattedStock: String {
        let stockDesc = "stock".localize
        return stockDesc + " : " + String(stock)
    }
    
    var variants = [ProductVariant]()
    
    var imageSize: CGSize?
    
    var key:String
    
    var ref: FIRDatabaseReference?
    
    static let jsonKeys:(name:String, category:String, imageURL: String, description : String, createdDate:String,  rating:String, price:String, variants: String, details: String) =
        (name:"name", category:"category", imageURL: "imageURL", description : "description",createdDate:"createdDate", rating:"rating", price:"price",variants: "variants", details: "details")
    
    public init(name: String, category: Category?, imageURL: String, stock: Int, description: String, price: Double, createdDate: Date, key:String = "") {
        self.name = name
        self.category = category
        self.imageURLs.append(imageURL)
        self.description = description
        self.price = price
        self.createdDate = createdDate
        self.key = key
    }
    
    init(snapshot: FIRDataSnapshot) {
        self.key = snapshot.key
        let jsonKeys = Product.jsonKeys
        
        let snapshotValue = snapshot.value as! [String: AnyObject]
        self.name  = snapshotValue[jsonKeys.name] as? String ?? ""
        self.description  = snapshotValue[jsonKeys.description] as? String ?? ""
        self.price = snapshotValue[jsonKeys.price] as? Double ?? 0
        
        if let timeStamp = snapshotValue[jsonKeys.createdDate] as? Double {
            self.createdDate = Date(timeIntervalSince1970: timeStamp)
        } else {
            self.createdDate = Date()
        }
        
        if let categoryID = snapshotValue[jsonKeys.category] as? String {
            self.category = CurrentCategories.filter({ $0.categoryID == categoryID}).first
        }
         
        self.rating = snapshotValue[jsonKeys.rating] as? Int ?? 0
        if let imageURLs = snapshotValue[jsonKeys.imageURL] as? [String] {
            self.imageURLs = imageURLs
        }
        
        if let variants = snapshotValue[jsonKeys.variants] as? [AnyObject] {
            for item in variants {
                guard let wItem = item as? [String: AnyObject] else { continue }
                let variant = ProductVariant(object: wItem)
                self.variants.append(variant)
            }
        }
        
        if let details = snapshotValue[jsonKeys.details] as? [AnyObject] {
            for item in details {
                guard let wItem = item as? [String: AnyObject] else { continue }
                let detail = ProductDetail(object: wItem)
                self.details.append(detail)
            }
        }
        
        self.ref = snapshot.ref
    }

    
}
