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
import FirebaseDatabase

typealias finishCompletion = ((_ isFinish: Bool) -> Void)
typealias finishMessageCompletion = ((_ isFinish: Bool, _ message:String?) -> Void)
class AuthController {
    fileprivate let userRef = FIRDatabase.database().reference(withPath: "users")
    
    func register(email:String, password:String, completion: @escaping finishMessageCompletion){
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            guard error == nil else {
                let message = (error as NSError?)?.code == ErrorCode.emailAlreadyExist.rawValue ? "emailAlreadyTaken" : "failedRegister"
                completion(false, message.localize)
                return
            }
            let uid = User.shared.uid
            let userData = ["userType" : UserType.email.rawValue]
            self.userRef.child(uid).setValue(userData)
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
            self.getUserProfile()
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
                
                
//                if let photoURL = User.shared.photoURL {
//                    User.shared.photoURL = photoURL + "?type=large"
//                }
//
                
                let uid = User.shared.uid
                let userData = ["userType" : UserType.facebook.rawValue]
                self.userRef.child(uid).setValue(userData)
                self.getUserProfile()
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
        let nav = UINavigationController(rootViewController: vc)
        
        guard let window = UIApplication.shared.keyWindow else { return }
        UIView.transition(with: window, duration: 0.3, options: UIViewAnimationOptions.curveEaseIn, animations: {
            window.rootViewController = nav
        }, completion: nil)
    }
    
    func updateUserProfile(name:String?,photoURL:String?,  completion: @escaping finishCompletion){
        let changeRequest = FIRAuth.auth()?.currentUser?.profileChangeRequest()
        changeRequest?.displayName = name
        if let wPhotoURL = photoURL{
            changeRequest?.photoURL = URL(string: wPhotoURL)
        }
        
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
    
    func reAuthenticate(oldPassword: String, completion: @escaping finishCompletion){
        guard let firUser = FIRAuth.auth()?.currentUser else { return }
        
        let crediential = FIREmailPasswordAuthProvider.credential(withEmail: User.shared.email, password: oldPassword)
        firUser.reauthenticate(with: crediential) { (error) in
            guard error == nil else {
                completion(false)
                return
            }
            
            completion(true)
        }
    }
    
    func updatePassword(password:String, completion: @escaping finishCompletion) {
        guard let firUser = FIRAuth.auth()?.currentUser else { return }
        firUser.updatePassword(password) { (error) in
            guard error == nil else {
                completion(false)
                return
            }
            
            completion(true)

        }
    }
    
    func getUserProfile(){
        DispatchQueue.global().async {
            self.userRef.child(User.shared.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                guard let value = snapshot.value as? [String:Any] else { return }
                guard let userType = value["userType"] as? String else { return }
                User.shared.userType = UserType(rawValue: userType) ?? .email
            })

        }
    }
}
