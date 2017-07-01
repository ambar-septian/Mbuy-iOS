//
//  AuthController.swift
//  MCommerce
//
//  Created by Ambar Septian on 7/1/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit
import FirebaseAuth
import Hero
import FBSDKLoginKit

typealias finishCompletion = ((_ isFinish: Bool) -> Void)
typealias finishMessageCompletion = ((_ isFinish: Bool, _ message:String?) -> Void)
class AuthController {
    func register(email:String, password:String, completion: @escaping finishMessageCompletion){
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            guard error == nil else {
                let message = (error as NSError?)?.code == ErrorCode.emailAlreadyExist.rawValue ? "emailAlreadyTaken" : "failedRegister"
                completion(false, message.localize)
                return
            }
            completion(true, nil)
        })
    }
    
    func login(email:String, password:String, completion: @escaping finishMessageCompletion){
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            guard error == nil else {
                let message = (error as NSError?)?.code == ErrorCode.wrongPassword.rawValue ? "wrongPassword" : "failedLogin"
                completion(false, message.localize)
                return
            }
            completion(true, nil)
        })
    }
    
    func loginWithFacebook(currentVC: UIViewController, completion: @escaping finishCompletion){
        let fbLogin = FBSDKLoginManager()
        let permission = ["public_profile", "email"]
        fbLogin.logIn(withReadPermissions: permission, from: currentVC) { (result, error) in
            guard error == nil, result != nil else {
                print("error \(error.debugDescription)")
                completion(false)
                return
            }
            
            guard !(result!.isCancelled) else {
                return
            }
            
            
            let credintial = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            
            FIRAuth.auth()?.signIn(with: credintial, completion: { (user, error) in
                guard error == nil else {
                    completion(false)
                    return
                }
                completion(true)
            })
        }
    }
    
    func dismissViewControllerToHome(currentVC: UIViewController){
        let storyboard = UIStoryboard(name: Constants.storyboard.home, bundle: nil)
        guard let tabBar = storyboard.instantiateViewController(withIdentifier: Constants.viewController.mainTabBar) as? UITabBarController else { return }
       
        
        guard let window = UIApplication.shared.keyWindow else { return }
        UIView.transition(with: window, duration: 0.3, options: UIViewAnimationOptions.curveEaseIn, animations: {
            window.rootViewController = tabBar
        }, completion: nil)
    }
    
    func dismissViewControllerToLogin(currentVC: UIViewController){
        let storyboard = UIStoryboard(name: Constants.storyboard.auth, bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: Constants.viewController.auth.login) as? LoginViewController else { return }
        
        
        guard let window = UIApplication.shared.keyWindow else { return }
        UIView.transition(with: window, duration: 0.3, options: UIViewAnimationOptions.curveEaseIn, animations: {
            window.rootViewController = vc
        }, completion: nil)
    }
    
    func updateProfileUser(name:String, completion: @escaping finishCompletion){
        let changeRequest = FIRAuth.auth()?.currentUser?.profileChangeRequest()
        changeRequest?.displayName = name
        changeRequest?.commitChanges(completion: { (error) in
            guard error == nil else {
                completion(false)
                return
            }
            completion(true)
        })
    }
    
    func resetPassword(email:String, completion: @escaping finishCompletion) {
        FIRAuth.auth()?.sendPasswordReset(withEmail: email, completion: { (error) in
            guard error == nil else {
                completion(false)
                return
            }
            completion(true)
        })
    }
    
    func logout(completion: @escaping finishCompletion){
        do {
            try FIRAuth.auth()?.signOut()
            completion(true)
            
        } catch let error {
            print("error logout \(error)")
            completion(false)
        }
    }
}
