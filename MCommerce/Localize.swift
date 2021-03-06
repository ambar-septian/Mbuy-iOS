//
//  Localize.swift
//  MCommerce
//
//  Created by Ambar Septian on 5/9/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import Foundation

class Localize {
    static let shared = Localize()
    private init() {}
    
    var language: Language {
        get {
            guard let localizes = UserDefaults.standard.value(forKey: Constants.userDefaultsKey.localize) as? [String] else {
                return .ID
            }
            
            guard let rawValue = localizes.first else {
                return .ID
            }
            
            switch(rawValue) {
            case "id":
                return .ID
            default:
                return .EN
            }
        }
        
        set {
            UserDefaults.standard.set([newValue.rawValue], forKey: Constants.userDefaultsKey.localize)
        }
    }
    
    var bundle: Bundle {
        let path = Bundle.main.path(forResource: language.rawValue, ofType: "lproj")!
        return Bundle(path: path)!
    }
}


enum Language: String {
    case ID = "id"
    case EN = "en"
}
