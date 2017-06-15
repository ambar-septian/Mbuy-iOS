//
//  User.swift
//  MCommerce
//
//  Created by Ambar Septian on 5/15/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import Foundation

class User {
    var email:String
    var firstName:String
    var lastName:String
    var address:String
    var userType: UserType
    
    var fullName:String {
        return firstName + " " + lastName
    }
    
    var profileImageURL: String?
    
    init(email:String, firstName:String, lastName:String, address:String, userType: UserType, profileImagePath:String?) {
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.address = address
        self.userType = userType
        self.profileImageURL = profileImagePath
    }
}

