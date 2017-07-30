//
//  BankPayment.swift
//  MCommerce
//
//  Created by Ambar Septian on 7/27/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit

enum BankPayment {
    case bca
    case bni
    case bri
    case mandiri
}

extension BankPayment {
    var bankName:String {
        switch self {
        case .bca:
            return "BCA"
        case .bni:
            return "BNI"
        case .bri:
            return "BRI"
        case .mandiri:
            return "Mandiri"
        }
    }
    
    var accountName:String {
        switch self {
        case .bca:
            return "M'Buy BCA"
        case .bni:
            return "M'Buy BNI"
        case .bri:
            return "M'Buy BRI"
        case .mandiri:
            return "M'Buy Mandiri"
        }
    }
    
    var accountNumber:String {
        switch self {
        case .bca:
            return "9500 000 000"
        case .bni:
            return "4500 000 000"
        case .bri:
            return "8200 000 000"
        case .mandiri:
            return "1720 000 000"
        }
    }
    
    var image:UIImage {
        switch self {
        case .bca:
            return #imageLiteral(resourceName: "bank_bca")
        case .bni:
            return #imageLiteral(resourceName: "bank_bni")
        case .bri:
            return #imageLiteral(resourceName: "bank_bri")
        case .mandiri:
            return #imageLiteral(resourceName: "bank_mandiri")
        }
    }
    
    private var userAccountNameDefaultsKey:String {
        switch self {
        case .bca:
            return "userAccountNamePaymentBCA"
        case .bni:
            return "userAccountNamePaymentBNI"
        case .bri:
            return "userAccountNamePaymentBRI"
        case .mandiri:
            return "userAccountNamePaymentMandiri"
        }
    }
    
    private var userAccountNumberDefaultsKey:String {
        switch self {
        case .bca:
            return "userAccountNumberPaymentBCA"
        case .bni:
            return "userAccountNumberPaymentBNI"
        case .bri:
            return "userAccountNumberPaymentBRI"
        case .mandiri:
            return "userAccountNumberPaymentMandiri"
        }
    }

    
    private var userDefaults: UserDefaults {
        return UserDefaults.standard
    }
    

    var userAccountNumber: String {
        get {
            return UserDefaults.standard.value(forKey: userAccountNumberDefaultsKey) as? String ?? ""
        }
        
        set {
            UserDefaults.standard.setValue(newValue, forKey: userAccountNumberDefaultsKey)
        }
    }
    
    
    var userAccountName: String {
        get {
            return UserDefaults.standard.value(forKey: userAccountNameDefaultsKey) as? String ?? ""
        }
        
        set {
            userDefaults.setValue(newValue, forKey: userAccountNameDefaultsKey)
        }
    }


}
