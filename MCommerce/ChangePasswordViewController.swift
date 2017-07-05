//
//  ChangePasswordViewController.swift
//  MCommerce
//
//  Created by Ambar Septian on 7/5/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit
import Iconic

class ChangePasswordViewController: BaseViewController {

    @IBOutlet weak var oldPasswordLabel: IconLabel! {
        didSet {
            oldPasswordLabel.text = "oldPassword".localize
            oldPasswordLabel.icon = .unlockIcon
            
        }
    }
    
    @IBOutlet weak var oldPasswordTextField: BorderTextField! {
        didSet {
            oldPasswordTextField.placeholder = "oldPassword".localize
        }
    }
    
    @IBOutlet weak var newPasswordLabel: IconLabel! {
        didSet {
            newPasswordLabel.text = "newPassword".localize
            newPasswordLabel.icon = .lockIcon
            
        }
    }
    
    
    
    @IBOutlet weak var newPasswordTextField: BorderTextField! {
        didSet {
            newPasswordTextField.placeholder = "newPassword".localize
        }
    }
    
    
    
    @IBOutlet weak var repeatPasswordLabel: IconLabel! {
        didSet {
            repeatPasswordLabel.text = "repeatPassword".localize
            repeatPasswordLabel.icon = .lockIcon
            
        }
    }
    
    
    @IBOutlet weak var repeatPasswordTextField: BorderTextField!  {
        didSet {
            repeatPasswordTextField.placeholder = "repeatPassword".localize
        }
    }
    
    @IBOutlet weak var saveBarButton: UIBarButtonItem! {
        didSet {
            saveBarButton.title = "save".localize
        }
    }
    
    fileprivate let controller = AuthController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "changePassword".localize
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func saveButtonTapped(_ sender: Any) {
        let validForm = validateForm()
        guard validForm.isValid else {
            Alert.showAlert(message: validForm.message ?? "", alertType: .okOnly, viewController: self)
            return
        }
        
        changePassword()
    
    }
}

extension ChangePasswordViewController {
    func changePassword(){
        showProgressHUD()
        DispatchQueue.global().async {
            self.controller.reAuthenticate(oldPassword: self.oldPasswordTextField.text ?? "", completion: { (completed) in
                guard completed else {
                    self.hideProgressHUD()
                    Alert.showAlert(message: "oldPasswordWrong".localize, alertType: .okOnly, viewController: self)
                    return
                }
                
                self.controller.updatePassword(password: self.newPasswordTextField.text ?? "", completion: { (completed) in
                    DispatchQueue.main.async {
                        self.hideProgressHUD()
                        guard completed else {
                            Alert.showAlert(message: "updatePasswordFailed".localize, alertType: .okOnly, viewController: self)
                            return
                        }
                        
                        Alert.showAlert(message: "changePasswordSuccess".localize, alertType: .okOnly, header: nil, viewController: self, handler: { (alert) in
                            self.navigationController?.popViewController(animated: true)
                        })
                    }
                    
                })
            })
        }
    }
    
    
    func validateForm() -> (isValid:Bool, message:String?) {
        let oldPassword = oldPasswordTextField.text
        let newPassword = newPasswordTextField.text
        let repeatPassword = repeatPasswordTextField.text
        
        let texts = [oldPassword, newPassword, repeatPassword]
        
        for (_,text) in texts.enumerated() {
            guard let wText = text, wText != "" else {
                return (isValid: false, message: "validEmptyForm".localize)
            }
            
            guard wText.characters.count >= 6 else {
                return (isValid: false, message: "passwordMinimumChar".localize)
            }
            
            guard newPassword == repeatPassword else {
                return (isValid: false, message: "passwordDoesntMatch".localize)
            }
            
        }
        
        return (isValid: true, message: nil)
    }
}


extension ChangePasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return handleTextFieldShouldReturn(textField)
    }
}
