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
    
  
    @IBOutlet weak var backBarButton: UIBarButtonItem! {
        didSet {
            backBarButton.title = "cancel".localize
        }
    }
    
    
    @IBOutlet weak var nextBarButton: UIBarButtonItem! {
        didSet {
            nextBarButton.title = "next".localize
        }
    }
    @IBOutlet weak var timelineView: HorizontalTimelineView!
    
    weak var delegate: CheckOutParentProtocol?
    
    @IBOutlet weak var headerView: UIView!
    
    var currentPage: Int = 0 {
        didSet {
            var title = "";
            switch currentPage {
            case 0:
                backBarButton.title = "cancel".localize
                title = "customerProfile".localize
            case 1:
                backBarButton.title = "back".localize
                nextBarButton.title = "next".localize
                 title = "deliveryAddress".localize
            case 2:
                nextBarButton.title = "finish".localize
                title = "summary".localize
            default:
                break
            
            }
            subtitleLabel.text =  title
            subtitleLabel.sizeToFit()
            customTitleView.frame.size.width = subtitleLabel.frame.width
            timelineView.moveActiveCircleView(index: currentPage)
            delegate?.didChildPageChange(index: currentPage)
            
        }
    }
    
    var passedCarts = [Cart]()
    
    var profile = OrderProfile()
    
    fileprivate let orderController = OrderController()
    
    fileprivate var order: Order? {
        guard let pageVC = childViewControllers.first as? CheckOutPageViewController else { return nil }
        guard let summaryVC = pageVC.childViewControllers.last as? CheckOutSummaryViewController else { return nil }
        return summaryVC.order
    }
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Checkout"
        label.textAlignment = .center
        label.textColor = Color.white
        label.font = Font.latoBold
        label.sizeToFit()
        
        return label
    }()
    
    fileprivate lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "customerProfile".localize
        label.textAlignment = .center
        label.textColor = Color.white
        label.font = Font.latoRegular.withSize(14)
        label.sizeToFit()
        
        return label
    }()
    
    
    fileprivate lazy var customTitleView: UIView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.distribution = .equalCentering
        
        stackView.addArrangedSubview(self.titleLabel)
        stackView.addArrangedSubview(self.subtitleLabel)
        stackView.spacing = 2
       
        let width = max(self.titleLabel.frame.width, self.subtitleLabel.frame.width)
        stackView.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: width, height: 35))
        
        
        return stackView
    }()
    
    
   
    override func viewDidLoad() {
        super.viewDidLoad()

        
        subtitleLabel.text = "customerProfile".localize
      
        setupChildView()
        title = "Checkout"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.titleView = customTitleView
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        timelineView.moveActiveCircleView(index: 0, withAnimation: false)
        self.timelineView.layoutSubviews()
    }
    
    @IBAction func previousButtonTapped(_ sender: Any) {
        guard currentPage != 0 else { return }
        currentPage -= 1
    }
    
 
    @IBAction func backButtonTapped(_ sender: Any) {
        view.endEditing(true)
        guard currentPage != 0 else {
            dismiss(animated: true, completion: nil)
            return
        }
        currentPage -= 1
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        view.endEditing(true)
        
        guard currentPage < 3 else { return }
        guard delegate != nil else { return }
        
        guard let formValid = delegate?.didFormIsValid() else { return }
        
        if formValid.isValid {
            delegate?.updateOrderProfile()
            currentPage += 1

            guard currentPage == 3 else { return }
            submitOrder()
        } else {
            guard let message = formValid.message else { return }
            Alert.showAlert(message: message, alertType: .okOnly, header: nil, viewController: self)
        }

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
    
    fileprivate func submitOrder(){
        guard let order = self.order else { return }
        showProgressHUD()
        DispatchQueue.global().async {
            self.orderController.submitOrder(order: order, completion: { (newOrderRef) in
                DispatchQueue.main.async {
                    self.hideProgressHUD()
                    guard let wNewOrderRef = newOrderRef else { return }
                    
                    order.ref = wNewOrderRef
                    self.orderController.finishSubmitOrder(order: order)
                    
                    let storyboard = UIStoryboard(name: Constants.storyboard.order, bundle: nil)
                    guard let vc = storyboard.instantiateViewController(withIdentifier: Constants.viewController.order.note) as? OrderNoteViewController else { return }
                    vc.passedOrder = order
                    self.pushNavigation(targetVC: vc)
                    
                }
            })
        }
        
    }
}
