//
//  RegisterViewController.swift
//  MCommerce
//
//  Created by Ambar Septian on 5/15/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit
import Iconic
import Anchorage
import Hero

class RegisterViewController: BaseViewController {
   
    
    @IBOutlet weak var emailTextField: RoundedTextField! {
        didSet {
            let size = CGSize(width: 20, height: 20)
            let image = FontAwesomeIcon.envelopeIcon.image(ofSize: size, color: Color.white)
             emailTextField.placeholder = "email".localize
            emailTextField.imagePlaceholder = image
           
        }
    }
    
    
    @IBOutlet weak var nameTextField: RoundedTextField! {
        didSet {
            let size = CGSize(width: 20, height: 20)
            let image = FontAwesomeIcon.userIcon.image(ofSize: size, color: Color.white)
            nameTextField.placeholder = "firstName".localize
            nameTextField.imagePlaceholder = image
            
        }
    }
    
    
    
    
    @IBOutlet weak var passwordTextField: RoundedTextField! {
        didSet {
            let size = CGSize(width: 20, height: 20)
            let image = FontAwesomeIcon.lockIcon.image(ofSize: size, color: Color.white)
            passwordTextField.placeholder = "password".localize
            passwordTextField.imagePlaceholder = image
        }
    }
    
    @IBOutlet weak var repeatPasswordTextField: RoundedTextField! {
        didSet {
            let size = CGSize(width: 20, height: 20)
            let image = FontAwesomeIcon.lockIcon.image(ofSize: size, color: Color.white)
            repeatPasswordTextField.placeholder = "repeatPassword".localize
            repeatPasswordTextField.imagePlaceholder = image
        }
    }
    
    @IBOutlet weak var registerButton: RoundedButton! {
        didSet {
            registerButton.setTitle("register".localize, for: .normal)
            registerButton.heroID = Constants.heroID.registerButton
        }
    }
    
    lazy var backgroundView: UIView = {
        return BackgroundLoginView(frame: CGRect.zero)
    }()
    
    fileprivate var controller = AuthController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
        addBackButton()
        setNavigationControllerBackground(color: Color.clear, isTranslucent: true)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension RegisterViewController {
    @IBAction func registerButtonTapped(_ sender: Any) {
        let validForm = validateForm()
        
        guard validForm.isValid else {
            Alert.showAlert(message: validForm.message ?? "", alertType: .okOnly, viewController: self)
            return
        }
        register()
        
    }
}

extension RegisterViewController {
    func validateForm() -> (isValid:Bool, message:String?) {
        let email = emailTextField.text
        let name = nameTextField.text
        let password = passwordTextField.text
        let repeatPassword = repeatPasswordTextField.text
        let texts = [email, name, password, repeatPassword]
        
        for (index,text) in texts.enumerated() {
            guard let wText = text, wText != "" else {
                return (isValid: false, message: "validEmptyForm".localize)
            }
            
            switch index {
            case 0: // email
                guard wText.isValidEmail else {
                    return (isValid: false, message: "validEmail".localize)
                }
            case 2, 3: // password doesn't match
                guard texts[2] ==  texts[3] else {
                    return (isValid: false, message: "passwordDoesntMatch".localize)
                }
                
                guard wText.characters.count >= 6  else {
                    return (isValid: false, message: "passwordMinimumChar".localize)
                }
                
            default:
                break
            }

        }
        
        return (isValid:true, message: nil)
    }
    
    fileprivate func register(){
        showProgressHUD()
        DispatchQueue.global().async {
            self.controller.register(email: self.emailTextField.text!, password: self.passwordTextField.text!, completion: { (completed, message) in
                
                DispatchQueue.main.async {
                    self.hideProgressHUD()
                    
                    guard completed else {
                        Alert.showAlert(message: message ?? "", alertType: .okOnly, viewController: self)
                        return
                    }
                    
                    self.setupUser()
                
                }
                
            })
        }
    }
    
    fileprivate func setupUser(){
        self.controller.updateProfileUser(name: nameTextField.text ?? "") { (completed) in
            guard completed else { return }
            self.controller.dismissViewControllerToHome(currentVC: self)
        }
    }
    

}

extension RegisterViewController: BaseViewProtocol {
    func setupSubviews() {
        view.insertSubview(backgroundView, at: 0)
        setupConstraints()
    }
    
    func setupConstraints(){
        backgroundView.edgeAnchors == view.edgeAnchors
    }
}

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return handleTextFieldShouldReturn(textField)
    }
}

