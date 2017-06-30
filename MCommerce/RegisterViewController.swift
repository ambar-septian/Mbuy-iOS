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
    
    
    @IBOutlet weak var firstNameTextField: RoundedTextField! {
        didSet {
            let size = CGSize(width: 20, height: 20)
            let image = FontAwesomeIcon.userIcon.image(ofSize: size, color: Color.white)
            firstNameTextField.placeholder = "firstName".localize
            firstNameTextField.imagePlaceholder = image
            
        }
    }
    
    
    @IBOutlet weak var lastNameTextField: RoundedTextField! {
        didSet {
            let size = CGSize(width: 20, height: 20)
            let image = FontAwesomeIcon.userIcon.image(ofSize: size, color: Color.white)
           
            lastNameTextField.placeholder = "lastName".localize
             lastNameTextField.imagePlaceholder = image
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
    
        @IBAction func registerButtonTapped(_ sender: Any) {
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

