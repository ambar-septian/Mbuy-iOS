//
//  OrderConfirmationViewController.swift
//  MCommerce
//
//  Created by Ambar Septian on 7/19/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit
import Iconic

class OrderPaymentViewController: BaseViewController {

    
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
    
    @IBOutlet weak var totalTransferLabel: UILabel!
    
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
    
    @IBOutlet weak var addPhotoButton: CircleImageButton! {
        didSet {
            addPhotoButton.icon = .cameraIcon
            addPhotoButton.mainColor = Color.orange
        }
    }
    
    @IBOutlet weak var photoTransferImageView: UIImageView! {
        didSet {
            photoTransferImageView.isUserInteractionEnabled = true
            photoTransferImageView.addGestureRecognizer(addPhotoGesture)
        }
    }
    
    @IBOutlet weak var addPhotoLabel: UILabel! {
        didSet {
            addPhotoLabel.text = "addPhoto".localize
            
        }
    }
    
    @IBOutlet weak var proofTransferLabel: IconLabel! {
        didSet {
            proofTransferLabel.text = "proofBankTransfer".localize
            proofTransferLabel.icon = FontAwesomeIcon.cameraIcon
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
    
    fileprivate var transferImage: UIImage? {
        didSet{
            photoTransferImageView.image = transferImage
            addPhotoButton.isHidden = true
            addPhotoLabel.isHidden = true
        }
    }
    
    lazy var formatter: NumberFormatter = {
        let formatter = NumberFormatter()
       
        formatter.groupingSeparator = "."
        formatter.numberStyle = .decimal
        
        return formatter
    }()
    
    
    lazy var imagePicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        return imagePicker
    }()
    
    lazy var addPhotoGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.addPhotoTapped(_:)))
        return gesture
    }()
    
    lazy var actionSheet: UIAlertController = {
        let actionSheet = UIAlertController(title: nil, message: "addPhoto".localize, preferredStyle: .actionSheet)
        
        let cameraButton = UIAlertAction(title: "takePhoto".localize, style: .default) { (alert) in
            let source:UIImagePickerControllerSourceType = UIImagePickerController.isSourceTypeAvailable(.camera) ? .camera : .photoLibrary
            self.imagePicker.sourceType = source
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        
        let selectButton = UIAlertAction(title: "selectPhoto".localize, style: .default) { (alert) in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        
        let cancelButton = UIAlertAction(title: "cancel".localize, style: .destructive) { (alert) in
            self.imagePicker.dismiss(animated: true, completion: nil)
        }
        
        
        actionSheet.addAction(cameraButton)
        actionSheet.addAction(selectButton)
        actionSheet.addAction(cancelButton)
        
        return actionSheet
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addPhotoButton.setNeedsDisplay()
    }
    
    @IBAction func addPhotoTapped(_ sender: Any) {
        present(actionSheet, animated: true, completion: nil)
    }

    @IBAction func confirmButtonTapped(_ sender: Any) {
        guard let order = passedOrder else { return }
        guard let ref = order.ref else { return }

        let formValid = validateForm()
        
        if formValid.isValid {
            // submit order
            
            let confirmation = OrderConfirmation(accountName: accountNameTextField.text ?? "", accountBank: accountPayment, accountNumber: accountNumberTextField.text ?? "", transferAmount: amountNumber, transferImageURL: "")
            controller.postOrderConfirmation(ref: ref, confirmation: confirmation, transferImage: transferImage!)
            

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

extension OrderPaymentViewController {
    func setupAccountPayment(){
        guard let payment = accountPayment else { return }
        guard let order = passedOrder else {
            return
        }
    
        totalTransferLabel.text = order.formattedTotal
    
        paymentImageView.image = payment.image
        paymentNameLabel.text = payment.accountName
        paymentAccountNumberLabel.text = payment.accountNumber
        bankNameLabel.text = payment.bankName
        
        accountNameTextField.text = payment.userAccountName
        accountNumberTextField.text = payment.userAccountNumber
    }
    
    func validateForm() -> (isValid:Bool, message:String?) {
        guard let order = passedOrder else {
            return (isValid: false, message: "validEmptyForm".localize)
        }
        
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
                    return (isValid: false, message: "validAccountNumber".localize)
                }
            case 2:
                guard amountNumber > 0 else {
                    return (isValid: false, message: "validZeroAmount".localize)
                }
                
                guard amountNumber >= order.total else {
                    return (isValid: false, message: "validTransferAmount".localize)
                }
                

            default:
                break
            }
        }
        
        guard transferImage != nil else {
            return (isValid: false, message: "validTranferImage".localize)
        }
        
        return (isValid: true, message: nil)
    }
}

extension OrderPaymentViewController: UITextFieldDelegate {
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

extension OrderPaymentViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            transferImage = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
