//
//  User.swift
//  MCommerce
//
//  Created by Ambar Septian on 5/15/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import Foundation
import FirebaseAuth

class User {
    fileprivate let firebaseUser = FIRAuth.auth()?.currentUser
    
    var email:String {
        get {
            return firebaseUser?.email ?? ""
        }
    }
    
    var name:String {
        get {
            return firebaseUser?.displayName ?? ""
        }
      
    }
    
    var photoURL:String? {
        get {
            return firebaseUser?.photoURL?.absoluteString
        }
        
    }

    

//    var userType: UserType {
//        get {
//            return firebaseUser?.displayName ?? ""
//        }
//    }

//    static let shared = FIRAuth.auth()?.currentUser
//    private init() {}
    
    
}

