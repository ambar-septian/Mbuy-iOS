//
//  OrderProfile.swift
//  MCommerce
//
//  Created by Ambar Septian on 6/22/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import Foundation
import CoreLocation

class OrderProfile {
    var name:String = ""
    var address:String = ""
    var coordinate: CLLocationCoordinate2D?
    var phone:String = ""
    var email:String = ""
    var note:String = ""
    var deliveryCost:Double = 0
    
    init(){
        
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
    
}
