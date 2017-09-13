//
//  OrderConfirmation.swift
//  MCommerce
//
//  Created by Ambar Septian on 8/8/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import Foundation
import FirebaseDatabase

class OrderConfirmation: FirebaseProtocol {
    var accountName: String
    var accountBank: BankPayment?
    var accountNumber: String
    var transferAmount: Double
    
    var key: String
    var ref: FIRDatabaseReference?
    
    
    static let jsonKeys:(accountName:String, bankName:String, accountNumber:String, transferAmount:String) =
        (accountName:"accountName", bankName:"bankName", accountNumber: "accountNumber", transferAmount:"transferAmount")
    
    init(accountName: String, accountBank:BankPayment?, accountNumber: String, transferAmount:Double) {
        self.accountName = accountName
        self.accountBank = accountBank
        self.accountNumber = accountNumber
        self.transferAmount = transferAmount
        self.key = ""
    }
    
    required init(snapshot: FIRDataSnapshot) {
        self.key = snapshot.key
        let jsonKeys = OrderConfirmation.jsonKeys
        ref = snapshot.ref
        
        let snapshotValue = snapshot.value as! [String: AnyObject]
        self.accountName = snapshotValue[jsonKeys.accountName] as? String ?? ""
        self.accountNumber = snapshotValue[jsonKeys.accountNumber] as? String ?? ""
        self.transferAmount = snapshotValue[jsonKeys.transferAmount] as? Double ?? 0
        
        guard let accountBank = snapshotValue[jsonKeys.bankName] as? String else { return }
        self.accountBank = BankPayment(rawValue: accountBank)
    }
    
    convenience init(dictionary: [String:Any]) {
        let jsonKeys = OrderConfirmation.jsonKeys
        
        let accountName = dictionary[jsonKeys.accountName] as? String ?? ""
        let accountNumber = dictionary[jsonKeys.accountNumber] as? String ?? ""
        let transferAmount = dictionary[jsonKeys.transferAmount] as? Double ?? 0
        
        self.init(accountName: accountName, accountBank: nil, accountNumber: accountNumber, transferAmount: transferAmount)
        
        guard let bankName = dictionary[jsonKeys.bankName] as? String else { return }
        self.accountBank = BankPayment(rawValue: bankName)

        
    }
    
    
}
