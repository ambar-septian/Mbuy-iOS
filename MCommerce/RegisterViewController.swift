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
    
    lazy var registerButton:RoundedButton = {
        let button = RoundedButton(backgroundColor: Color.clear, borderColor: Color.white, borderWidth: 2)
        button.setTitle("register".localize, for: .normal)
        button.heroID = HeroID.registerButton
        return button
    }()
    
    
    lazy var emailTextField: RoundedTextField = {
        let size = CGSize(width: 20, height: 20)
        let image = FontAwesomeIcon.envelopeIcon.image(ofSize: size, color: Color.white)
        let textField = RoundedTextField(borderColor: Color.white, borderWidth: 1, mainColor: Color.orange.withAlphaComponent(0.5), imagePlaceholder: image)
        textField.placeholder = "email".localize
        textField.keyboardType = .emailAddress
        textField.delegate = self
        textField.tag = 2
        textField.returnKeyType = .next
        return textField
    }()
    
    
    
    lazy var passwordTextField: RoundedTextField = {
        let size = CGSize(width: 20, height: 20)
        let image = FontAwesomeIcon.lockIcon.image(ofSize: size, color: Color.white)
        let textField = RoundedTextField(borderColor: Color.white, borderWidth: 1, mainColor: Color.orange.withAlphaComponent(0.5), imagePlaceholder: image)
        textField.placeholder = "password".localize
        textField.isSecureTextEntry = true
        textField.delegate = self
        textField.tag = 3
        textField.returnKeyType = .next
        return textField
    }()
    
    lazy var repeatPasswordTextField: RoundedTextField = {
        let size = CGSize(width: 20, height: 20)
        let image = FontAwesomeIcon.lockIcon.image(ofSize: size, color: Color.white)
        let textField = RoundedTextField(borderColor: Color.white, borderWidth: 1, mainColor: Color.orange.withAlphaComponent(0.5), imagePlaceholder: image)
        textField.placeholder = "repeatPassword".localize
        textField.isSecureTextEntry = true
        textField.delegate = self
        textField.tag = 4
        textField.returnKeyType = .done
        return textField
    }()
    
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var backgroundView: UIView = {
        return BackgroundLoginView(frame: CGRect.zero)
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension RegisterViewController: BaseViewProtocol {
    func setupSubviews() {
        view.addSubview(backgroundView)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(emailTextField)
        contentView.addSubview(passwordTextField)
        contentView.addSubview(repeatPasswordTextField)
        contentView.addSubview(registerButton)
        
        setupConstraints()
    }
    
    func setupConstraints(){
        backgroundView.edgeAnchors == view.edgeAnchors
        
        scrollView.horizontalAnchors == view.horizontalAnchors
        scrollView.topAnchor == view.topAnchor + 40
        scrollView.bottomAnchor == view.bottomAnchor
        
        contentView.edgeAnchors == scrollView.edgeAnchors
        contentView.widthAnchor == scrollView.widthAnchor
        
        emailTextField.horizontalAnchors == contentView.horizontalAnchors + 30
        emailTextField.topAnchor == contentView.topAnchor + 20
        emailTextField.heightAnchor == 50
        
        passwordTextField.horizontalAnchors == emailTextField.horizontalAnchors
        passwordTextField.topAnchor == emailTextField.bottomAnchor + 20
        passwordTextField.heightAnchor == 50
        
        repeatPasswordTextField.horizontalAnchors == emailTextField.horizontalAnchors
        repeatPasswordTextField.topAnchor == passwordTextField.bottomAnchor + 20
        repeatPasswordTextField.heightAnchor == 50
        
        registerButton.horizontalAnchors == emailTextField.horizontalAnchors
        registerButton.topAnchor == repeatPasswordTextField.bottomAnchor + 20
        registerButton.bottomAnchor == contentView.bottomAnchor + 10
        registerButton.heightAnchor == 50
       
        
    }
}

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return handleTextFieldShouldReturn(textField)
    }
}

