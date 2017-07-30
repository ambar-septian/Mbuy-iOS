//
//  OrderPayment.swift
//  MCommerce
//
//  Created by Ambar Septian on 6/23/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit

class OrderPayment {
    var bankName: String
    var accountNumber:String
    var accountName:String
    var image: UIImage?
    
    init(bankName:String, accountNumber:String, accountName:String, image:UIImage?) {
        self.bankName = bankName
        self.accountName = accountName
        self.accountNumber = accountNumber
        self.image = image
    }
    
}
