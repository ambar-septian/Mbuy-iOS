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
    func registerDidTapped(sender: UIButton){
        let vc = RegisterViewController()
        navigationController? .pushViewController(vc, animated: true)
//        pushNavigation(targetVC: vc)
    }
    
    func forgotPasswordDidTapped(sender: UIButton) {
        let vc = ForgotPasswordViewController()
        navigationController?.pushViewController(vc, animated: true)
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
