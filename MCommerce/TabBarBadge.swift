//
//  TabBarBadge.swift
//  MCommerce
//
//  Created by Ambar Septian on 7/3/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit

class TabBarBadge {
    private init () {}
    static let shared = TabBarBadge()
    
    fileprivate let userDefaults = UserDefaults.standard
    fileprivate let userDefaultsKey = Constants.userDefaultsKey.tabBarBadge.self
    
    var tabBarController: UITabBarController? {
        didSet {
            updateCartBadge()
            updateOrderBadge()
        }
    }
    
    var cartCount:Int {
        get {
            return userDefaults.value(forKey: userDefaultsKey.cart) as? Int ?? 0
        }
        
        set {
            userDefaults.setValue(newValue, forKey: userDefaultsKey.cart)
            updateCartBadge()
        }
    }
    
    var orderCount:Int {
        get {
            return userDefaults.value(forKey: userDefaultsKey.order) as? Int ?? 0
        }
        
        set {
            userDefaults.setValue(newValue, forKey: userDefaultsKey.order)
            updateOrderBadge()
        }
    }
    
    fileprivate func updateCartBadge(){
        let value = cartCount == 0 ? nil : String(cartCount)
        tabBarController?.tabBar.items?[2].badgeValue = value
    }

    
    fileprivate func updateOrderBadge(){
        let value = orderCount == 0 ? nil : String(orderCount)
        tabBarController?.tabBar.items?[3].badgeValue = value
    }

    
    
}
