//
//  Font.swift
//  MCommerce
//
//  Created by Ambar Septian on 5/15/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit
import Iconic

struct Font {
    static let defaultSize:CGFloat = 16
    
    private static var defaultFont: UIFont {
        return UIFont().withSize(Font.defaultSize)
    }
    
    static var latoRegular: UIFont {
        return UIFont(name: "Lato-Regular", size: Font.defaultSize) ?? Font.defaultFont
    }
    
    static var latoBold: UIFont {
        return UIFont(name: "Lato-Bold", size: Font.defaultSize) ?? Font.defaultFont
    }
    
    static var latoLight: UIFont {
        return UIFont(name: "Lato-Regular", size: Font.defaultSize) ?? Font.defaultFont
    }
    
  
}
