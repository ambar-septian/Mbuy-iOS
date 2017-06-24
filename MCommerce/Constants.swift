//
//  Constants.swift
//  MCommerce
//
//  Created by Ambar Septian on 5/9/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit

enum Constants {
    static let cornerRadius:CGFloat = 6
    
    enum segueID {
        static let showProductDetail = "ShowProductDetail"
        enum order {
            static let note = "orderNote"
            static let history = "orderHistory"
            static let detail = "orderDetail"
        }
    }
    
    enum viewTag {
        static let scrollView = 99
    }
    
    
    enum userDefaultsKey {
        static let localize = "AppleLanguages"
    }
    
    enum heroID {
        static let registerButton = "registerButton"
        static let forgotPasswordButton = "forgotPasswordButton"
        static let productThumbnail = "productThumbnail"
        static let productPreview = "productPreview"
    }
    
    enum storyboard {
        static let product = "Product"
        static let search = "Search"
    }
    
    enum viewController {
        enum product {
            static let detail = "ProductDetailViewControllerID"
            static let preview = "ProductPreviewViewControllerID"
            static let list = "ProductListViewControllerID"
        }
        
        enum order {
            static let main = "OrderListViewControllerID"
            static let page = "OrderPageViewControllerID"
            static let child = "OrderListChildViewControllerID"
            static let history = "OrderHistoryViewControllerID"
        }
    }
    
    enum notification {
        static let updateStepper = Notification.Name(rawValue: "updateStepperNotification")
    }


}



enum DateFormat {
    case dateLong
    case timeMedium
    case dateTime
}

