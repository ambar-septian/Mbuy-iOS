//
//  Alert.swift
//  MCommerce
//
//  Created by Ambar Septian on 6/27/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit

class Alert {
    class func showAlert(message:String,alertType: AlertType, header title:String?, viewController vc: UIViewController, handler: ((UIAlertAction) -> Void)? = nil){
        
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: handler))
        
        if alertType == .okCancel {
            alert.addAction(UIAlertAction(title: "cancel".localize, style: .default, handler: nil))
            
        }
        
        vc.present(alert, animated: true, completion: nil)

    }
    
}

enum AlertType {
    case okOnly
    case okCancel
}
