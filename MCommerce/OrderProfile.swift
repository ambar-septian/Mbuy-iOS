//
//  OrderProfile.swift
//  MCommerce
//
//  Created by Ambar Septian on 6/22/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import Foundation
import CoreLocation
import FirebaseDatabase

class OrderProfile: FirebaseProtocol {
    var name:String = ""
    var address:String = ""
    var coordinate: CLLocationCoordinate2D?
    var phone:String = ""
    var email:String = ""
    var note:String = ""
    var deliveryCost:Double = 0
    
    var key: String
    var ref: FIRDatabaseReference?
    
    init(){
        self.key = ""
    }
    
    static let jsonKeys:(name:String, email:String, phone:String, note:String, deliveryCost:String, address:String, latitude: String, longitude : String) =
        (name:"name", email:"email", phone: "phone", note:"note", deliveryCost:"deliveryCost", address:"address", latitude: "latitude", longitude : "longitude")
    
    convenience init(name: String, address:String, coordinate: CLLocationCoordinate2D, phone:String, email:String, note:String, deliveryCost: Double) {
        self.init()
        self.name = name
        self.address = address
        self.coordinate = coordinate
        self.phone = phone
        self.email = email
        self.note = note
        self.deliveryCost = deliveryCost
    }
    
    required init(snapshot: FIRDataSnapshot) {
        self.key = snapshot.key
        let jsonKeys = OrderProfile.jsonKeys
        ref = snapshot.ref
        
        let snapshotValue = snapshot.value as! [String: AnyObject]
        self.name = snapshotValue[jsonKeys.name] as? String ?? ""
        self.address = snapshotValue[jsonKeys.address] as? String ?? ""
        self.phone = snapshotValue[jsonKeys.phone] as? String ?? ""
        self.email = snapshotValue[jsonKeys.email] as? String ?? ""
        self.note = snapshotValue[jsonKeys.note] as? String ?? ""
        self.deliveryCost = snapshotValue[jsonKeys.deliveryCost] as? Double ?? 0
        
        let latitude = snapshotValue[jsonKeys.latitude] as? Double
        let longitude = snapshotValue[jsonKeys.longitude] as? Double
        
        guard longitude != nil, latitude != nil else { return }
        let coordinate = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
        self.coordinate = coordinate
    }
    
}
