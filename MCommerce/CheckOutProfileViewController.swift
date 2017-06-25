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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension CheckOutProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return handleTextFieldShouldReturn(textField)
    }
}
