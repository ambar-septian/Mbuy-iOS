//
//  Constants.swift
//  MCommerce
//
//  Created by Ambar Septian on 5/9/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit
import CoreLocation

enum Constants {
    static let cornerRadius:CGFloat = 6
    
    enum segueID {
        static let showProductDetail = "ShowProductDetail"
        enum order {
            static let payment = "orderPayment"
            static let history = "orderHistory"
            static let detail = "orderDetail"
            static let confirmation = "orderConfirmation"
            static let note = "orderNote"
        }
        
        enum setting {
            static let changeLanguage = "changeLanguage"
            static let changePassword = "changePassword"
            static let editProfile = "editProfile"
        }
        
        enum checkout {
            static let main = "checkOutMain"
        }
        
        enum product {
            static let list = "productList"
        }
    }
    
    enum viewTag {
        static let scrollView = 99
        static let snapshotView = 91
    }
    
    
    enum userDefaultsKey {
        static let localize = "AppleLanguages"
        
        enum tabBarBadge {
            static let cart = "CartTabBarBadge"
            static let order = "OrderTabBarBadge"
        }
        
        enum orderProfile {
            static let name = "orderProfileName"
            static let email = "orderProfileEmail"
            static let phone = "orderProfilePhone"
            static let accountNumber = "orderProfileAccountNumber"
            static let accountName = "orderProfileAccountName"
        }
        
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
        static let cart = "Cart"
        static let home = "Home"
        static let auth = "Authentication"
        static let order = "Order"
    }
    
    enum viewController {
        enum product {
            static let detail = "ProductDetailViewControllerID"
            static let preview = "ProductPreviewViewControllerID"
            static let list = "ProductListViewControllerID"
            static let confirmation = "ProductConfirmationViewControllerID"
        }
        
        enum order {
            static let main = "OrderListViewControllerID"
            static let page = "OrderPageViewControllerID"
            static let child = "OrderListChildViewControllerID"
            static let history = "OrderHistoryViewControllerID"
            static let note = "OrderNoteViewControllerID"
        }
        
        enum checkout {
            static let main = "CheckOutMainViewControllerID"
            static let page = "CheckOutPageViewControllerID"
            static let profile = "CheckOutProfileViewControllerID"
            static let address = "CheckOutAddressViewControllerID"
            static let summary = "CheckOutSummaryViewControllerID"
        }
        
        enum home {
            static let main = "HomeViewControllerID"
        }
        
        enum auth {
            static let login = "LoginViewControllerID"
        }
        
        static let mainTabBar = "MainTabBarControllerID"
    }
    
    enum notification {
        static let updateStepper = Notification.Name(rawValue: "updateStepperNotification")
    }

    enum GMAP {
        static let mapKey = "AIzaSyCtSih3Yy8B6Fmf2bcQquXn3OTNNGEpHaA"
        static let placeKey = "AIzaSyCpRajf4X6Bn7YtFTVngve-Kto9J96t7uQ"
        static let defaultCoordinate = CLLocationCoordinate2D(latitude: -6.121435, longitude: 106.774124)
        static let indonesiaFarLeftCoordinate = CLLocationCoordinate2D(latitude: -10.1718, longitude: 95.31644)
        static let indonesiaFarRightCoordinate = CLLocationCoordinate2D(latitude: 5.88969, longitude: 140.71813)
    }
    
    static let deliveryPrice:Double = 5000
}



enum DateFormat {
    case dateLong
    case timeMedium
    case dateTime
}

enum ImagePlaceHolder:String {
    case user = "user"
    case base = "logo-white-small"
}

enum FacebookLoginResult {
    case success
    case failed
    case cancel
}

