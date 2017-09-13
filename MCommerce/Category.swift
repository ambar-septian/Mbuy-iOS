//
//  Category.swift
//  MCommerce
//
//  Created by Ambar Septian on 5/10/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import Foundation
import Firebase

class Category: FirebaseProtocol {
    var name: String {
        return Localize.shared.language == .ID ? nameID : nameEN
    }
    var imageURL: String
    
    var key: String
    var ref: FIRDatabaseReference?
    
    var categoryID:String {
        return key
    }
    
    fileprivate var nameID:String
    
    fileprivate var nameEN:String
    
    var isClothing: Bool = false
    
    var orderNumber: Int
    
    static let jsonKeys:(nameEN:String, nameID:String, imageURL: String, orderNumber : String, isClothing: String) =
        (nameEN: "nameEN", nameID:"nameID", imageURL: "imageURL", orderNumber : "orderNumber", isClothing: "isClothing")
    
    public init(nameID: String, nameEN:String, imageURL: String, orderNumber:Int,key:String = "") {
        self.nameID = nameID
        self.nameEN = nameEN
        self.imageURL = imageURL
        self.orderNumber = orderNumber
        self.key = key
    }
    
    required init(snapshot: FIRDataSnapshot) {
        self.key = snapshot.key
        let jsonKeys = Category.jsonKeys
        
        let snapshotValue = snapshot.value as! [String: AnyObject]
        self.nameEN  = snapshotValue[jsonKeys.nameEN] as? String ?? ""
        self.nameID  = snapshotValue[jsonKeys.nameID] as? String ?? ""
        self.imageURL = snapshotValue[jsonKeys.imageURL] as? String ?? ""
        self.orderNumber = snapshotValue[jsonKeys.orderNumber] as? Int ?? 0
        self.isClothing = snapshotValue[jsonKeys.isClothing] as? Bool ?? false
        ref = snapshot.ref
    }
    
}
