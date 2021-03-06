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
    
    @IBOutlet weak var loginButton: RoundedButton! {
        didSet {
           loginButton.setTitle("login".localize, for: .normal)
        }
    }
    
    
    @IBOutlet weak var facebookButton: RoundedButton! {
        didSet {
            let icon = FontAwesomeIcon.facebookIcon.attributedString(ofSize: 16, color: Color.white)
            let attributeTitle = NSMutableAttributedString()
            let title = NSAttributedString(string: " " + "Facebook", attributes: [NSForegroundColorAttributeName: Color.white])
            attributeTitle.append(icon)
            attributeTitle.append(title)
            
            facebookButton.setAttributedTitle(attributeTitle, for: .normal)
            facebookButton.mainColor = Color.facebook
            facebookButton.borderColor = Color.facebook
        }
    }
    
    @IBOutlet weak var emailTextField: RoundedTextField! {
        didSet {
            let size = CGSize(width: 20, height: 20)
            let image = FontAwesomeIcon.envelopeIcon.image(ofSize: size, color: Color.white)
            emailTextField.placeholder = "email".localize
            emailTextField.imagePlaceholder = image
        }
    }
    
    @IBOutlet weak var passwordTextField: RoundedTextField! {
        didSet {
            let size = CGSize(width: 20, height: 20)
            let image = FontAwesomeIcon.lockIcon.image(ofSize: size, color: Color.white)
            passwordTextField.imagePlaceholder = image
            passwordTextField.placeholder = "password".localize
        }
    }
    
    
    @IBOutlet weak var registerButton: UIButton! {
        didSet {
        registerButton.setTitle("dontHaveAccount".localize, for: .normal)
        registerButton.heroID = Constants.heroID.registerButton
        }
    }
    
    @IBOutlet weak var forgetPasswordButton: UIButton! {
        didSet {
            forgetPasswordButton.setTitle("forgetPassword".localize, for:.normal)
            forgetPasswordButton.heroID = Constants.heroID.forgotPasswordButton
        }
    }

    @IBOutlet weak var orSignLabel: UILabel! {
        didSet {
            orSignLabel.text = "orSignInWith".localize
        }
    }
    
    
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
    
    let controller = AuthController()

    override func viewDidLoad() {
        super.viewDidLoad()
     
        setupSubviews()
        
        navigationController?.isHeroEnabled = true
        
//        setNavigationControllerBackground(color: Color.clear, isTranslucent: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

extension LoginViewController {
    func validateForm() -> (isValid:Bool, message:String?) {
        let email = emailTextField.text
        let password = passwordTextField.text
        
        let texts = [email, password]
        
        for (index,text) in texts.enumerated() {
            guard let wText = text, wText != "" else {
                return (isValid: false, message: "validEmptyForm".localize)
            }
            
            switch index {
            case 2: // email
                guard wText.isValidEmail else {
                    return (isValid: false, message: "validEmail".localize)
                }
            default:
                break
            }
        }
        
        return (isValid:true, message: nil)
    }
    
    fileprivate func login(){
        showProgressHUD()
        DispatchQueue.global().async {
            self.controller.login(email: self.emailTextField.text!, password: self.passwordTextField.text!, completion: { (completed, message) in
                
                DispatchQueue.main.async {
                    self.hideProgressHUD()
                    
                    guard completed else {
                        Alert.showAlert(message: message ?? "", alertType: .okOnly, viewController: self)
                        return
                    }
                    
                    self.controller.dismissViewControllerToHome(currentVC: self)
                }
             
            })
        }
    }

        
}

extension LoginViewController {
    @IBAction func loginButtonTapped(_ sender: Any) {
        let validForm = validateForm()
        
        guard validForm.isValid else {
            Alert.showAlert(message: validForm.message ?? "", alertType: .okOnly, viewController: self)
            return
        }
        login()
    }
    
    @IBAction func facebookButtonTapped(_ sender: Any) {
        showProgressHUD()
        controller.loginWithFacebook(currentVC: self) { (result) in
            self.hideProgressHUD()
            
            switch result {
            case .success:
                self.controller.dismissViewControllerToHome(currentVC: self)
            case .failed:
                Alert.showAlert(message: "failedLogin".localize, alertType: .okOnly, viewController: self)
            default:
                break
            }
            
            
        }
    }
}



extension LoginViewController: BaseViewProtocol {
    func setupSubviews() {
        view.insertSubview(backgroundView, at: 0)
        setupConstraints()
    }
    
    func setupConstraints(){
        backgroundView.edgeAnchors == view.edgeAnchors
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       return handleTextFieldShouldReturn(textField)
    }
}
