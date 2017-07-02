//
//  ForgotPasswordViewController.swift
//  MCommerce
//
//  Created by Ambar Septian on 5/22/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit
import Iconic
import Anchorage

class ForgotPasswordViewController: BaseViewController {
   
    @IBOutlet weak var emailTextField: RoundedTextField! {
        didSet {
            let size = CGSize(width: 20, height: 20)
            let image = FontAwesomeIcon.envelopeIcon.image(ofSize: size, color: Color.white)
            emailTextField.imagePlaceholder = image
            emailTextField.placeholder = "email".localize
        }
    }

    
    @IBOutlet weak var instructionLabel: UILabel! {
        didSet {
            instructionLabel.text = "instructionForgotPassword".localize
        }
    }
    @IBOutlet weak var submitButton: RoundedButton! {
        didSet {
            submitButton.setTitle("submit".localize, for: .normal)
            submitButton.heroID = Constants.heroID.forgotPasswordButton
        }
    }

    lazy var backgroundView: UIView = {
        return BackgroundLoginView(frame: CGRect.zero)
    }()
    
    let controller = AuthController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
        setNavigationControllerBackground(color: Color.clear, isTranslucent: true)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension ForgotPasswordViewController {
    @IBAction func forgotPassword(_ sender: Any) {
        let validForm = validateForm()
        guard validForm.isValid else {
            Alert.showAlert(message: validForm.message ?? "", alertType: .okOnly, viewController: self)
            return
        }
        resetPassword()
    }
}

extension ForgotPasswordViewController {
    func validateForm() -> (isValid:Bool, message:String?) {
        let text = emailTextField.text
        guard let wText = text, wText != "" else {
            return (isValid: false, message: "validEmptyForm".localize)
        }
        
        guard wText.isValidEmail else {
            return (isValid: false, message: "validEmail".localize)
        }
        
        return (isValid:true, message: nil)
    }
    
    func resetPassword(){
        showProgressHUD()
        DispatchQueue.global().async {
            self.controller.resetPassword(email: self.emailTextField.text!, completion: { (success) in
                
                DispatchQueue.main.async {
                    self.hideProgressHUD()
                    
                    guard success else {
                        Alert.showAlert(message: "failedResetPassword".localize, alertType: .okOnly, viewController: self)
                        return
                    }
                    
                    Alert.showAlert(message: "resetPasswordSuccess".localize, alertType: .okOnly, viewController: self)
                }
                
            })
        }
    }

}


extension ForgotPasswordViewController: BaseViewProtocol {
    func setupSubviews() {
        view.insertSubview(backgroundView, at: 0)
        setupConstraints()
    }
    
    func setupConstraints() {
        backgroundView.edgeAnchors == view.edgeAnchors
    }
}

extension ForgotPasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return handleTextFieldShouldReturn(textField)
    }
}
