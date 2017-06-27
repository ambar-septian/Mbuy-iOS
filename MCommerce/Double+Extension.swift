//
//  Double+Extension.swift
//  MCommerce
//
//  Created by Ambar Septian on 5/25/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import Foundation

extension Double {
    var formattedPrice: String {
        let formater = NumberFormatter()

//        formater.currencyDecimalSeparator = ","
//        formater.currencyGroupingSeparator = "."
        formater.locale = Locale(identifier: "id")
        formater.numberStyle = .currency
        formater.currencySymbol = "Rp"
        formater.minimumFractionDigits = 0
        
        return formater.string(from: NSNumber(value: self)) ?? String(self)
        
    }
}
