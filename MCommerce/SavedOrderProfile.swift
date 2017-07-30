//
//  SavedOrderProfile.swift
//  MCommerce
//
//  Created by Ambar Septian on 7/21/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import Foundation

class SavedOrderProfile {
    
    private let userDefaults = UserDefaults.standard.self
    private let constant = Constants.userDefaultsKey.orderProfile.self
    
    static let shared = SavedOrderProfile()
    private init(){}

    
    var name: String {
        get {
            return userDefaults.value(forKey: constant.name) as? String ?? ""
        }
        
        set {
            userDefaults.setValue(newValue, forKey: constant.name)
        }
    }
    
    var email: String {
        get {
            return userDefaults.value(forKey: constant.email) as? String ?? ""
        }
        
        set {
            userDefaults.setValue(newValue, forKey: constant.email)
        }
    }

    
    var phone: String {
        get {
            return userDefaults.value(forKey: constant.phone) as? String ?? ""
        }
        
        set {
            userDefaults.setValue(newValue, forKey: constant.phone)
        }
    }

    
    var accountNumber: String {
        get {
            return userDefaults.value(forKey: constant.accountNumber) as? String ?? ""
        }
        
        set {
            userDefaults.setValue(newValue, forKey: constant.accountNumber)
        }
    }

    
    var accountName: String {
        get {
            return userDefaults.value(forKey: constant.accountName) as? String ?? ""
        }
        
        set {
            userDefaults.setValue(newValue, forKey: constant.accountName)
        }
    }

}
