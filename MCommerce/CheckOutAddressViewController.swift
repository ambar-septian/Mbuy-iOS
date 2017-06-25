//
//  CheckOutAddressViewController.swift
//  MCommerce
//
//  Created by Ambar Septian on 6/25/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit
import Iconic

class CheckOutAddressViewController: BaseViewController {
    
    @IBOutlet weak var addressLabel: IconLabel! {
        didSet {
            addressLabel.icon = FontAwesomeIcon.homeIcon
        }
    }

    @IBOutlet weak var noteLabel: IconLabel! {
        didSet {
            noteLabel.icon = FontAwesomeIcon.editIcon
        }
    }
    
    @IBOutlet weak var deliveryCostHeadingLabel:  IconLabel! {
        didSet {
            deliveryCostHeadingLabel.icon = FontAwesomeIcon.truckIcon
        }
    }
    
    @IBOutlet weak var deliveryLabel: UILabel! {
        didSet {
            deliveryLabel.text = Double(0).formattedPrice
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
