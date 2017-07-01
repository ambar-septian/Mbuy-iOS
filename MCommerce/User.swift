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
    
    var uid:String {
        get {
            return firebaseUser?.uid ?? ""
        }
    }
    
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
    
    
    static let shared = User()
    private init() {}
    

//    var userType: UserType {
//        get {
//            return firebaseUser?.displayName ?? ""
//        }
//    }


    
    
}

