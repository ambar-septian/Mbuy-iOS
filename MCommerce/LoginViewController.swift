//
//  ViewController.swift
//  MCommerce
//
//  Created by Ambar Septian on 5/9/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit
import Iconic
import Anchorage
import Hero

class LoginViewController: BaseViewController {
    
    lazy var loginButton:RoundedButton = {
       let button = RoundedButton(backgroundColor: Color.clear, borderColor: Color.white, borderWidth: 2)
        button.setTitle("login".localize, for: .normal)
        return button
    }()
    
    lazy var facebookButton:RoundedButton = {
        let button = RoundedButton(backgroundColor: Color.facebook, borderColor: Color.facebook, borderWidth: 2)
        let icon = FontAwesomeIcon.facebookIcon.attributedString(ofSize: 16, color: Color.white)
        let attributeTitle = NSMutableAttributedString()
        let title = NSAttributedString(string: " " + "Facebook", attributes: [NSForegroundColorAttributeName: Color.white])
        attributeTitle.append(icon)
        attributeTitle.append(title)
        
        button.setAttributedTitle(attributeTitle, for: .normal)
        return button
    }()
    
    lazy var emailTextField: RoundedTextField = {
        let size = CGSize(width: 20, height: 20)
        let image = FontAwesomeIcon.envelopeIcon.image(ofSize: size, color: Color.white)
        let textField = RoundedTextField(borderColor: Color.white, borderWidth: 1, mainColor: Color.orange.withAlphaComponent(0.7), imagePlaceholder: image)
        textField.placeholder = "email".localize
        textField.keyboardType = .emailAddress
        textField.returnKeyType = .next
        textField.delegate = self
        textField.tag = 0
        return textField
    }()
    
    lazy var passwordTextField: RoundedTextField = {
        let size = CGSize(width: 20, height: 20)
        let image = FontAwesomeIcon.lockIcon.image(ofSize: size, color: Color.white)
        let textField = RoundedTextField(borderColor: Color.white, borderWidth: 1, mainColor: Color.orange.withAlphaComponent(0.7), imagePlaceholder: image)
        textField.placeholder = "password".localize
        textField.isSecureTextEntry = true
        textField.returnKeyType = .done
        textField.delegate = self
        textField.tag = 1
        return textField
    }()
    
    lazy var registerButton: BasicButton = {
        let button = BasicButton(title: "doesntHaveAccount".localize, color: Color.white)
        button.heroID = Constants.heroID.registerButton
        button.addTarget(self, action: #selector(registerDidTapped(sender:)), for: .touchUpInside)
        return button
    }()
    
    lazy var forgetPasswordButton: BasicButton = {
        let button = BasicButton(title: "forgetPassword".localize, color: Color.white)
        button.heroID = Constants.heroID.forgotPasswordButton
        button.addTarget(self, action: #selector(forgotPasswordDidTapped(sender:)), for: .touchUpInside)
        return button
    }()
    
    lazy var orSignLabel: BasicLabel = {
        let label = BasicLabel(text: "orSignInWith".localize, color: Color.white)
        return label
    }()
    
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.tag = Constants.viewTag.scrollView
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
        
        navigationController?.isHeroEnabled = true
        setNavigationControllerBackground(color: Color.clear, isTranslucent: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension LoginViewController {
    func registerDidTapped(sender: UIButton){
        let vc = RegisterViewController()
        navigationController?.pushViewController(vc, animated: true)
//        pushNavigation(targetVC: vc)
    }
    
    func forgotPasswordDidTapped(sender: UIButton) {
        let vc = ForgotPasswordViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension LoginViewController: BaseViewProtocol {
    func setupSubviews() {
        view.addSubview(backgroundView)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(emailTextField)
        contentView.addSubview(passwordTextField)
        contentView.addSubview(orSignLabel)
        contentView.addSubview(loginButton)
        contentView.addSubview(facebookButton)
        contentView.addSubview(registerButton)
        contentView.addSubview(forgetPasswordButton)
        
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
        
        loginButton.topAnchor == passwordTextField.bottomAnchor + 30
        loginButton.horizontalAnchors == emailTextField.horizontalAnchors
        loginButton.heightAnchor == 50
        
        orSignLabel.centerXAnchor == contentView.centerXAnchor
        orSignLabel.topAnchor == loginButton.bottomAnchor + 20
        
        facebookButton.topAnchor == orSignLabel.bottomAnchor + 20
        facebookButton.horizontalAnchors == emailTextField.horizontalAnchors
        facebookButton.heightAnchor == 50
    
        registerButton.leadingAnchor == contentView.leadingAnchor + 10
        registerButton.bottomAnchor == contentView.bottomAnchor + 10
        registerButton.topAnchor == facebookButton.bottomAnchor + 40
      
        forgetPasswordButton.trailingAnchor == contentView.trailingAnchor - 10
        forgetPasswordButton.topAnchor == registerButton.topAnchor
        
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       return handleTextFieldShouldReturn(textField)
    }
}
