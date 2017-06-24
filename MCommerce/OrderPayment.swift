//
//  OrderPayment.swift
//  MCommerce
//
//  Created by Ambar Septian on 6/23/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit

class OrderPayment {
    var name: String
    var accountNumber:String
    var image: UIImage?
    
    init(name:String, accountNumber:String, image:UIImage?) {
        self.name = name
        self.accountNumber = accountNumber
        self.image = image
    }
    
}
