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
    var firstName:String
    var lastName:String
    var address:String
    var coordinate: CLLocationCoordinate2D
    var phone:String
    var email:String
    
    var fullName:String {
        return firstName + " " + lastName
    }
    
    init(firstName: String, lastName:String, address:String, coordinate: CLLocationCoordinate2D, phone:String, email:String) {
        self.firstName = firstName
        self.lastName = lastName
        self.address = address
        self.coordinate = coordinate
        self.phone = phone
        self.email = email
    }
    
}
