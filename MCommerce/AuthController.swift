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
import FirebaseStorage

typealias finishCompletion = ((_ isFinish: Bool) -> Void)
typealias facebookLoginCompletion = ((_ loginResult: FacebookLoginResult) -> Void)
typealias finishMessageCompletion = ((_ isFinish: Bool, _ message:String?) -> Void)
typealias downloadURLCompletion = ((_ downloadURL: URL?) -> Void)

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
            let userData = ["userType" : UserType.email.rawValue, "photoURL" : ""]
            self.userRef.child(uid).setValue(userData)
            completion(true, nil)
        })
    }
    
    func login(email:String, password:String, completion: @escaping finishMessageCompletion){
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            guard error == nil else {
                let errorCode = (error as NSError?)?.code
                let message =  errorCode == ErrorCode.wrongPassword.rawValue || errorCode == ErrorCode.userDoesntExist.rawValue ? "wrongPassword" : "failedLogin"
                completion(false, message.localize)
                return
            }
            self.getUserProfile()
            completion(true, nil)
        })
    }
    
    func loginWithFacebook(currentVC: UIViewController, completion: @escaping facebookLoginCompletion){
        let fbLogin = FBSDKLoginManager()
        let permission = ["public_profile", "email"]
        fbLogin.logIn(withReadPermissions: permission, from: currentVC) { (result, error) in
            guard error == nil, result != nil else {
                print("error \(error.debugDescription)")
                completion(.failed)
                return
            }
            
            guard !(result!.isCancelled) else {
                completion(.cancel)
                return
            }
            
            
            let credintial = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            
            FIRAuth.auth()?.signIn(with: credintial, completion: { (user, error) in
                guard error == nil else {
                    completion(.failed)
                    return
                }
                
                var photoURL = ""
                if let fbPhotoURL = user?.photoURL {
                    photoURL = fbPhotoURL.absoluteString + "?type=large"
                }

                self.userRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    guard !(snapshot.exists()) else {
                        // user facebook exist
                        completion(.success)
                        return
                    }
                    
                    let uid = User.shared.uid
                    let userData = ["userType" : UserType.facebook.rawValue, "photoURL" : photoURL]
                    self.userRef.child(uid).setValue(userData)
                
                    self.updateUserProfile(name: nil, photoURL: photoURL, completion: { (completed) in
                        guard completed else { return }
                        self.getUserProfile()
                        
                        completion(.success)
                    })
                })
           
               
            })
        }
    }
    
    func dismissViewControllerToHome(currentVC: UIViewController){
        let storyboard = UIStoryboard(name: Constants.storyboard.home, bundle: nil)
        guard let tabBar = storyboard.instantiateViewController(withIdentifier: Constants.viewController.mainTabBar) as? UITabBarController else { return }
       
        guard let window = UIApplication.shared.keyWindow else { return }
        guard let rootViewController = window.rootViewController else { return }
        
        tabBar.view.frame = rootViewController.view.frame
        tabBar.view.layoutIfNeeded()
//        let snapShot = window.snapshotView(afterScreenUpdates: true)
       
        UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: { 
            window.rootViewController = tabBar
            
        }, completion: nil)
//        
//        UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseInOut, animations: {
//            snapShot?.layer.opacity = 0
//
//        }) { (completed) in
//            guard completed else { return }
//            snapShot?.removeFromSuperview()
//
//        }
    }
    
    func dismissViewControllerToLogin(currentVC: UIViewController){
        let storyboard = UIStoryboard(name: Constants.storyboard.auth, bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: Constants.viewController.auth.login) as? LoginViewController else { return }
        let nav = UINavigationController(rootViewController: vc)
        
        guard let window = UIApplication.shared.keyWindow else { return }
        let snapShot = window.snapshotView(afterScreenUpdates: true)
        window.rootViewController = nav
        
        UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseInOut, animations: {
            snapShot?.layer.opacity = 0
            
        }) { (completed) in
            guard completed else { return }
            snapShot?.removeFromSuperview()
            
        }
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
    
    func uploadUserProfile(image:UIImage, completion: @escaping downloadURLCompletion){
        guard let data = UIImageJPEGRepresentation(image, 0.5) else {
             completion(nil)
            return
        }
      
        let storageRef = FIRStorage.storage().reference().child("userimages/\(User.shared.uid).jpg")
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/jpeg"
        storageRef.put(data, metadata: metadata) { (metadata, error) in
           
            guard error == nil else {
                completion(nil)
                return
            }
            
            guard let downloadURL = metadata?.downloadURL() else {
                 completion(nil)
                return
            }
            
             completion(downloadURL)
        }
    }
    
}
