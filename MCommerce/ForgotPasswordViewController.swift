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
