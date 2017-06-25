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
        }
    }
    
    @IBOutlet weak var timelineView: HorizontalTimelineView!
    
    weak var delegate: CheckOutParentProtocol?
    
    @IBOutlet weak var headingLabel: UILabel!
    
    var currentPage: Int = 0 {
        didSet {
            timelineView.moveActiveCircleView(index: currentPage)
            delegate?.didChildPageChange(index: currentPage)
            
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
                title = "summary".localize
            default:
                break
            
            }
            
            headingLabel.text =  title
            
        }
    }
    
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
    
    @IBAction func previousButtonTapped(_ sender: Any) {
        guard currentPage != 0 else { return }
        currentPage -= 1
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        guard currentPage < 3 else { return }
        currentPage += 1

    }
    
}

extension CheckOutMainViewController {
    
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
    
//    func didChangeChildPage(row:Int){
//        let tabButtons = [processButton, completeButton]
//        for (index, button) in tabButtons.enumerated() {
//            if index == row  {
//                guard activePageIndex != index else { return }
//                
//                button?.setTitleColor(Color.orange, for: .normal)
//                self.lineLeadingConstraint?.constant = index == tabButtons.count - 1 ? self.view.bounds.width * 0.5 : 0
//                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
//                    self.view.layoutIfNeeded()
//                    
//                }, completion: nil)
//                delegate?.didChildPageChange(index: index)
//                activePageIndex = index
//            } else {
//                button?.setTitleColor(Color.lightGray, for: .normal)
//            }
//        }
//        
//    }
}
