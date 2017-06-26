//
//  CheckOutProfileViewController.swift
//  MCommerce
//
//  Created by Ambar Septian on 6/25/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit
import Iconic

class CheckOutProfileViewController: BaseViewController {

    @IBOutlet weak var firstNameLabel: IconLabel! {
        didSet {
            firstNameLabel.text = "firstName".localize
            firstNameLabel.icon = FontAwesomeIcon.userIcon
        }
    }

    @IBOutlet weak var lastNameLabel: IconLabel!  {
        didSet {
            lastNameLabel.text = "lastName".localize
            lastNameLabel.icon = FontAwesomeIcon.userIcon
        }
    }
    
    @IBOutlet weak var phoneLabel: IconLabel!  {
        didSet {
            phoneLabel.text = "phone".localize
            phoneLabel.icon = FontAwesomeIcon.mobilePhoneIcon
        }
    }
    
    @IBOutlet weak var emailLabel: IconLabel!  {
        didSet {
            emailLabel.text = "E-mail"
            emailLabel.icon = FontAwesomeIcon.envelopeIcon
        }
    }
    
    @IBOutlet weak var firstNameTextField: BorderTextField!  {
        didSet {
            firstNameTextField.placeholder = "firstName".localize
        }
    }
    
    
    @IBOutlet weak var lastNameTextField: BorderTextField!  {
        didSet {
            lastNameTextField.placeholder = "lastName".localize
        }
    }
    
    @IBOutlet weak var phoneTextField: BorderTextField!  {
        didSet {
            phoneTextField.placeholder = "phone".localize
        }
    }
    
    @IBOutlet weak var emailTextField: BorderTextField! {
        didSet {
            emailTextField.placeholder = "E-mail"
        }
    }
    
    weak var childDelegate: CheckOutChildProtocol?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension CheckOutProfileViewController {
    func validateForm() -> (isValid:Bool, message:String?) {
        let firstName = firstNameTextField.text
        let lastName = lastNameTextField.text
        let email = emailTextField.text
        let phone = phoneTextField.text
        
        let texts = [firstName, lastName, email, phone]
      
        for (index,text) in texts.enumerated() {
            guard let wText = text, wText != "" else {
                return (isValid: false, message: "validEmptyForm".localize)
            }
            
            switch index {
            case 2: // email
                guard wText.isValidEmail else {
                   return (isValid: false, message: "validEmail".localize)
                }
            case 3: // phone
                guard wText.isValidNumeric else {
                    return (isValid: false, message: "validPhone".localize)
                }
            default:
                break
            }
        }
        
        return (isValid: true, message: nil)
    }
}

extension CheckOutProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return handleTextFieldShouldReturn(textField)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        childDelegate?.didBeginTypingComponent()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        childDelegate?.didEndTypingComponent()
        return true
    }
}
