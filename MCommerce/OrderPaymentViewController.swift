//
//  OrderConfirmationViewController.swift
//  MCommerce
//
//  Created by Ambar Septian on 7/19/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit
import Iconic

class OrderConfirmationViewController: BaseViewController {

    
    @IBOutlet weak var paymentImageView: UIImageView!
    
    @IBOutlet weak var paymentNameLabel: UILabel!
    
    
    @IBOutlet weak var paymentAccountNumberLabel: UILabel!
    
    @IBOutlet weak var bankNameLabel: UILabel!
    
    @IBOutlet weak var accountNumberLabel: IconLabel! {
        didSet {
            accountNumberLabel.text = "accountNumber".localize
            accountNumberLabel.icon = FontAwesomeIcon.creditCardIcon
        }
    }
    
    @IBOutlet weak var accountNumberTextField: BorderTextField!
    
    @IBOutlet weak var accountNameLabel: IconLabel! {
        didSet {
            accountNameLabel.text = "accountName".localize
            accountNameLabel.icon = FontAwesomeIcon.userIcon
        }
    }
    
    @IBOutlet weak var accountNameTextField: BorderTextField!
    
    @IBOutlet weak var accountAmountLabel: IconLabel! {
        didSet {
            accountAmountLabel.text = "transferAmount".localize
            accountAmountLabel.icon = FontAwesomeIcon.moneyIcon
        }
    }
    
    
    @IBOutlet weak var accountAmountTextField: BorderTextField!
    
    @IBOutlet weak var confirmBarButton: UIBarButtonItem! {
        didSet {
            confirmBarButton.title = "submit".localize
        }
    }
    
    fileprivate let controller = OrderController()
    
    fileprivate var amountNumber:Double {
        guard let amountText =  accountAmountTextField.text else { return 0 }
        var amountValue = amountText.replacingOccurrences(of: currencySymbol, with: "")
        amountValue = amountValue.replacingOccurrences(of: ".", with: "")
        
        return Double(amountValue) ?? 0
    }
    
    var accountPayment: BankPayment?
    
    var passedOrder: Order?
    
    fileprivate var amountTypedString = ""
    
    fileprivate var currencySymbol = "Rp. "
    
    lazy var formatter: NumberFormatter = {
        let formatter = NumberFormatter()
       
        formatter.groupingSeparator = "."
        formatter.numberStyle = .decimal
        
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "confirmationPayment".localize
        
        setupAccountPayment()
    }
    
  

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func confirmButtonTapped(_ sender: Any) {
        guard let order = passedOrder else { return }
        guard let ref = order.ref else { return }
        guard var payment = accountPayment else { return }
        
        let formValid = validateForm()
        
        if formValid.isValid {
            // submit order
            controller.postOrderConfirmation(ref: ref, accountName: accountNameTextField.text ?? "", accountNumber: accountNumberTextField.text ?? "", transferAmount: amountNumber )
            
            // save number to user defaults
            payment.userAccountName = accountNameTextField.text ?? ""
            payment.userAccountNumber = accountNumberTextField.text ?? ""
            
            // show alert
            Alert.showAlert(message:"" , alertType: .okOnly, header: "confirmationPaymentSuccess".localize, viewController: self, handler: {  alert in
                guard let rootViewController = self.navigationController?.viewControllers.first else {
                    return
                }
                
                if rootViewController.isKind(of: CheckOutMainViewController.self) {
                    self.dismissVC()
                    TabBarBadge.shared.orderCount += 1
                } else {
                    self.navigationController?.popToRootViewController(animated: true)
                }
                
            })
        } else {
            guard let message = formValid.message else { return }
            Alert.showAlert(message: message, alertType: .okOnly, viewController: self)
        }
        
        
    }
}

extension OrderConfirmationViewController {
    func setupAccountPayment(){
        guard let payment = accountPayment else { return }
        paymentImageView.image = payment.image
        paymentNameLabel.text = payment.accountName
        paymentAccountNumberLabel.text = payment.accountNumber
        bankNameLabel.text = payment.bankName
        
        accountNameTextField.text = payment.userAccountName
        accountNumberTextField.text = payment.userAccountNumber
    }
    
    func validateForm() -> (isValid:Bool, message:String?) {
        let accountNumber = accountNumberTextField.text
        let accountName = accountNameTextField.text
        let amount = accountAmountTextField.text
        
        let texts = [accountNumber, accountName, amount]
        
        for (index,text) in texts.enumerated() {
            guard let wText = text, wText != "" else {
                return (isValid: false, message: "validEmptyForm".localize)
            }
            
            switch index {
            case 0: // account number
                guard wText.isValidNumeric else {
                    return (isValid: false, message: "validAmountString".localize)
                }
            case 2:
                guard amountNumber > 0 else {
                    return (isValid: false, message: "validZeroAmount".localize)
                }

            default:
                break
            }
        }
        
        return (isValid: true, message: nil)
    }
}

extension OrderConfirmationViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard textField == accountAmountTextField else { return true}
        
        
        if string.characters.count > 0 {
            amountTypedString += string
            let decNumber = NSDecimalNumber(string:(amountTypedString))
            let newString = currencySymbol +  formatter.string(from: decNumber)!
            textField.text = newString
        } else {
            amountTypedString = String(amountTypedString.characters.dropLast())
            if amountTypedString.characters.count > 0 {
                
                let decNumber = NSDecimalNumber(string:(amountTypedString))
                let newString = currencySymbol +   formatter.string(from:decNumber)!
                textField.text = newString
            } else {
                textField.text = currencySymbol + "0"
            }
            
        }
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return handleTextFieldShouldReturn(textField)
    }
}
