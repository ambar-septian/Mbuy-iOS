//
//  Color.swift
//  MCommerce
//
//  Created by Ambar Septian on 5/10/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit

class Color {
    
    static var orange:UIColor {
        return Color.rgbColor(r: 255, g: 130, b: 92, a: 1)
    }
    
    static var facebook:UIColor {
        return Color.rgbColor(r: 59, g: 89, b: 152, a: 1)
    }
    
    static var yellow:UIColor {
        return Color.rgbColor(r: 255, g: 130, b: 204, a: 1)
    }
    
    static var cream:UIColor {
        return Color.rgbColor(r: 245, g: 240, b: 236, a: 1)
    }
    
    static var green:UIColor {
        return Color.rgbColor(r: 0, g: 163, b: 136, a: 1)
    }
    
    static var red:UIColor {
        return Color.rgbColor(r: 255, g: 111, b: 105, a: 1)
    }
    
    static var lightGray: UIColor {
        return UIColor.lightGray
    }
    
    static var darkGray: UIColor {
        return UIColor.darkGray
    }
   
    static var clear: UIColor {
        return UIColor.clear
    }
    
    static var white: UIColor {
        return UIColor.white
    }
    
    static var black: UIColor {
        return UIColor.black
    }
  
    static var grayShadow: UIColor {
        return Color.rgbColor(r: 155, g: 155, b: 155, a: 0.3)
    }
    
    static func hexToColor (_ hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.white
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return rgbColor(
            r: CGFloat((rgbValue & 0xFF0000) >> 16),
            g: CGFloat((rgbValue & 0x00FF00) >> 8),
            b: CGFloat(rgbValue & 0x0000FF),
            a: CGFloat(1.0)
        )
        
    }
    
    static func rgbColor(r: CGFloat, g: CGFloat, b: CGFloat, a:CGFloat) -> UIColor {
        return UIColor(red: r / 255, green: g / 255, blue: b / 255, alpha: a)
    }
//    
//    func findColorFromTwoColor(firstColor:UIColor, secondColor: UIColor, index:CGFloat) -> UIColor{
//        let red = (firstColor.redValue + index * (secondColor.redValue - firstColor.redValue))
//        let green = (firstColor.greenValue + index * (secondColor.greenValue - firstColor.greenValue))
//        let blue = (firstColor.blueValue + index * (secondColor.blueValue - firstColor.blueValue))
//        
//        
//        return UIColor(red: red, green: green, blue: blue, alpha: 1)
//    }
}
