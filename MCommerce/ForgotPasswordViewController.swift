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
    
    lazy var instructionLabel: BasicLabel = {
        let label = BasicLabel(text: "instructionForgotPassword".localize, color: Color.white)
        return label
    }()
    

    lazy var forgotButton:RoundedButton = {
        let button = RoundedButton(backgroundColor: Color.clear, borderColor: Color.white, borderWidth: 2)
        button.setTitle("login".localize, for: .normal)
        button.heroID = HeroID.forgotPasswordButton
        return button
    }()
    

    lazy var backgroundView: UIView = {
        return BackgroundLoginView(frame: CGRect.zero)
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ForgotPasswordViewController: BaseViewProtocol {
    func setupSubviews() {
        view.addSubview(backgroundView)
        view.addSubview(emailTextField)
        view.addSubview(instructionLabel)
        view.addSubview(forgotButton)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        backgroundView.edgeAnchors == view.edgeAnchors
        
        emailTextField.horizontalAnchors == view.horizontalAnchors + 20
        emailTextField.topAnchor == view.topAnchor + 40
        emailTextField.heightAnchor == 50
        
        instructionLabel.topAnchor == emailTextField.bottomAnchor + 20
        instructionLabel.horizontalAnchors == emailTextField.horizontalAnchors
        
        forgotButton.topAnchor == instructionLabel.bottomAnchor + 30
        forgotButton.horizontalAnchors == emailTextField.horizontalAnchors
        forgotButton.heightAnchor == 50
        
    }
}

extension ForgotPasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return handleTextFieldShouldReturn(textField)
    }
}
