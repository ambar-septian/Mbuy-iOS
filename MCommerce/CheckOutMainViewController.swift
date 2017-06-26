//
//  CheckOutMainViewController.swift
//  MCommerce
//
//  Created by Ambar Septian on 6/25/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit

protocol CheckOutParentProtocol: class {
    func didChildPageChange(index:Int)
    func didFormIsValid() -> (isValid:Bool, message: String?)
    func updateOrderProfile()
}

protocol CheckOutChildProtocol: class {
    func didBeginTypingComponent()
    func didEndTypingComponent()
}

class CheckOutMainViewController: BaseViewController {
    
    @IBOutlet weak var childView: UIView!
    
    @IBOutlet weak var previousButton: BasicButton! {
        didSet {
            previousButton.setTitle("back".localize, for: .normal)
            previousButton.isHidden = true
        }
    }
    
    @IBOutlet weak var nextButton: BasicButton! {
        didSet {
            nextButton.setTitle("next".localize, for: .normal)
            nextButton.titleLabel?.adjustsFontSizeToFitWidth = true
        }
    }
    
    @IBOutlet weak var timelineView: HorizontalTimelineView!
    
    weak var delegate: CheckOutParentProtocol?
    
    @IBOutlet weak var headingLabel: UILabel!
    
    @IBOutlet weak var headerView: UIView!
    
    var currentPage: Int = 0 {
        didSet {
                        var title = "";
            switch currentPage {
            case 0:
                previousButton.isHidden = true
                title = "customerProfile".localize
            case 1:
                previousButton.isHidden = false
                previousButton.setTitle("back".localize, for: .normal)
                nextButton.setTitle("next".localize, for: .normal)
                 title = "deliveryAddress".localize
            case 2:
                nextButton.setTitle("finish".localize, for: .normal)
                nextButton.setNeedsLayout()
                title = "summary".localize
            default:
                break
            
            }
            headingLabel.text =  title
            timelineView.moveActiveCircleView(index: currentPage)
            delegate?.didChildPageChange(index: currentPage)
            
        }
    }
    
    var passedCarts = [Cart]()
    
    var profile = OrderProfile()
    
    var currentDeliveryCost:Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addDismissBarButton()
        headingLabel.text = "customerProfile".localize
        title = "Checkout"
      
        setupChildView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
     
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        timelineView.moveActiveCircleView(index: 0, withAnimation: false)
    }
    
    @IBAction func previousButtonTapped(_ sender: Any) {
        guard currentPage != 0 else { return }
        currentPage -= 1
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        guard currentPage < 3 else { return }
        guard delegate != nil else { return }
        
        let formValid = delegate!.didFormIsValid()
//        if formValid.isValid {
//            delegate?.updateOrderProfile()
//            currentPage += 1
//        } else {
//            guard let message = formValid.message else { return }
//            Alert.showAlert(message: message, alertType: .okOnly, header: nil, viewController: self)
//        }
        
        currentPage += 1

    }
    
}


extension CheckOutMainViewController {
    fileprivate func setupChildView(){
        guard let vc = storyboard?.instantiateViewController(withIdentifier: Constants.viewController.checkout.page) as? CheckOutPageViewController else { return }
        //        vc.childDelegate = self
        addChildViewController(vc)
        vc.view.frame = childView.bounds
        childView.addSubview(vc.view)
        vc.didMove(toParentViewController: self)
    }
}
