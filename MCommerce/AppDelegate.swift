//
//  AppDelegate.swift
//  MCommerce
//
//  Created by Ambar Septian on 5/9/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit
import Iconic
import Firebase
import FirebaseMessaging
import FBSDKCoreKit
import FacebookLogin
import GoogleMaps
import GooglePlaces
import Fabric
import Crashlytics
import UserNotifications



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Register Fontawesome
        FontAwesomeIcon.register()
        
        GMSServices.provideAPIKey(Constants.GMAP.mapKey)
        GMSPlacesClient.provideAPIKey(Constants.GMAP.placeKey)
        
        UIApplication.shared.statusBarStyle = .lightContent
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        Fabric.with([Crashlytics.self])
       
        setRootViewController()
     
        
        self.window?.tintColor = Color.orange
        BaseViewController.adjustNavigationBar()
        BaseViewController.adjustBarButtonItem()
        
        
        return true
    }
    
    override init(){
        super.init()
        // Configure Firebase
        FIRApp.configure()
        registerPushNotification()
//        FIRDatabase.database().persistenceEnabled = true
        
    }
    
    func registerPushNotification(){
        UNUserNotificationCenter.current().delegate = self
        FIRMessaging.messaging().remoteMessageDelegate = self
        
        let authOptions : UNAuthorizationOptions =  [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { (granted, error) in
            print("Permission granted: \(granted)")
            
            guard granted else { return }
            self.getNotificationSettings()
        }
    }
    
    func getNotificationSettings(){
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            guard settings.authorizationStatus == .authorized else { return }
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
   
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
    }
    

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
       
        
        FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: .sandbox)
        FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: .prod)
        
        let currentToken = FIRInstanceID.instanceID().token() ?? "Token null"
        print("Device Token: \(currentToken)")
        
        connectToFCM()
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        FIRMessaging.messaging().disconnect()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        connectToFCM()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

extension AppDelegate {
    func setRootViewController() {
        let vc: UIViewController
        if let _ = FIRAuth.auth()?.currentUser {
            AuthController().getUserProfile()
            
            let storyboard = UIStoryboard(name: Constants.storyboard.home, bundle: nil)
            vc = storyboard.instantiateViewController(withIdentifier: Constants.viewController.mainTabBar)
        } else {
            let storyboard = UIStoryboard(name: Constants.storyboard.auth, bundle: nil)
            let loginVC = storyboard.instantiateViewController(withIdentifier: Constants.viewController.auth.login)
            vc = UINavigationController(rootViewController: loginVC)
        }
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = vc
        self.window?.makeKeyAndVisible()
    }
    
    func setOrderViewController() {
        guard let _ = FIRAuth.auth()?.currentUser else { return }
        
        AuthController().getUserProfile()
        let storyboard = UIStoryboard(name: Constants.storyboard.home, bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: Constants.viewController.mainTabBar) as? UITabBarController else {
            return
        }
        
        vc.selectedIndex = 4
        
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = vc
        self.window?.makeKeyAndVisible()
    }
}

extension AppDelegate {
    func connectToFCM(){
        guard FIRInstanceID.instanceID().token() != nil else {
            print("fcm token nil")
            return
        }
        
        FIRMessaging.messaging().disconnect()
        
        FIRMessaging.messaging().connect { (error) in
            guard error == nil else {
                print("unable to connect FCM " + error.debugDescription)
                return
            }
            
            print("connect FCM")
        }
    }
}

extension AppDelegate: FIRMessagingDelegate {
    func applicationReceivedRemoteMessage(_ remoteMessage: FIRMessagingRemoteMessage) {
        print("notification foreground")
    }
    
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        guard let orderID = response.notification.request.content.userInfo["orderID"] as? String else {
            completionHandler()
            return
        }
        print("notification did receive")
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("notificaiton will present")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        FIRMessaging.messaging().appDidReceiveMessage(userInfo)
        print(userInfo.debugDescription)
    }
}

