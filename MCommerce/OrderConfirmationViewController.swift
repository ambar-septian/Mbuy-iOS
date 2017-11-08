//
//  OrderConfirmationViewController.swift
//  MCommerce
//
//  Created by Ambar Septian on 8/8/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit
import Iconic

class OrderConfirmationViewController: BaseViewController {
    
    @IBOutlet weak var confirmationLabel: UILabel! {
        didSet {
            confirmationLabel.text = "alreadyConfirmation".localize
        }
    }
    
    @IBOutlet weak var bankNameLabel: UILabel!
    
    @IBOutlet weak var bankImageView: UIImageView!
    
    
    @IBOutlet weak var accountNumberHeadingLabel: IconLabel! {
        didSet {
            accountNumberHeadingLabel.text = "accountNumber".localize
            accountNumberHeadingLabel.icon = FontAwesomeIcon.creditCardIcon
            
        }
    }
    
    @IBOutlet weak var accountNumberLabel: UILabel!
    
    @IBOutlet weak var accountNameHeadingLabel: IconLabel!  {
        didSet {
            accountNameHeadingLabel.text = "accountName".localize
            accountNameHeadingLabel.icon = FontAwesomeIcon.userIcon
        }
    }
    
    @IBOutlet weak var accountNameLabel: UILabel!
    
    @IBOutlet weak var transferAmountHeadingLabel: IconLabel! {
        didSet {
            transferAmountHeadingLabel.text = "transferAmount".localize
            transferAmountHeadingLabel.icon = FontAwesomeIcon.moneyIcon
        }
    }
    
    
    @IBOutlet weak var transferAmountLabel: UILabel!
    
    
    @IBOutlet weak var proofTransferLabel: IconLabel! {
        didSet {
            proofTransferLabel.text = "proofBankTransfer".localize
            proofTransferLabel.icon = FontAwesomeIcon.cameraIcon
        }
    }
    
    
    @IBOutlet weak var historyBarButton: UIBarButtonItem! {
        didSet {
            historyBarButton.title = "history".localize
        }
    }
    
    @IBOutlet weak var transferImageview: UIImageView!
    
    var passedOrder: Order?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupOrder()
        title = "confirmation".localize
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == Constants.segueID.order.history else { return }
        guard let vc = segue.destination as? OrderHistoryViewController else { return }
        vc.passedOrder = passedOrder
        
    }
    
    
    
    @IBAction func historyBarButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: Constants.segueID.order.history, sender: nil)
    }
}

extension OrderConfirmationViewController {
    func setupOrder(){
        guard let confirmation = passedOrder?.confirmation else { return }
        accountNameLabel.text = confirmation.accountName
        accountNumberLabel.text = confirmation.accountNumber
        transferAmountLabel.text = confirmation.transferAmount.formattedPrice
        transferImageview.setImage(urlString: confirmation.transferImageURL, placeholder: .base, completion: nil)
        
        bankNameLabel.text = confirmation.accountBank?.bankName ?? ""
        bankImageView.image = confirmation.accountBank?.image
        
        
    }
}
