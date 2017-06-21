//
//  Date+Extension.swift
//  MCommerce
//
//  Created by Ambar Septian on 6/13/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import Foundation
import SwiftDate


extension Date {
    func formattedDate(dateFormat: DateFormat) -> String{
        let locale = Locale(identifier: Localize.shared.language.rawValue)
        let region = Region(tz: TimeZone.current, cal: Calendar.current, loc: locale)
        let date = DateInRegion(absoluteDate: self, in: region)
        
        switch dateFormat {
        case .dateLong:
            return date.string(dateStyle: .long, timeStyle: .none)
        case .timeMedium:
            return date.string(dateStyle: .none, timeStyle: .medium)
            
//        default:
//            return date.string(dateStyle: .short, timeStyle: .short)
        }
    }
}
