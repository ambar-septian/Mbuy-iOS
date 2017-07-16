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
        label.font = Font.latoRegular.withSize(15)
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
        stackView.spacing = 5
       
        let width = max(self.titleLabel.frame.width, self.subtitleLabel.frame.width)
        stackView.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: width, height: 35))
        
        
        return stackView
    }()
    
    
   
    override func viewDidLoad() {
        super.viewDidLoad()

        addDismissBarButton()
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
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        guard currentPage < 3 else { return }
        guard delegate != nil else { return }
        
        let formValid = delegate!.didFormIsValid()
        
        delegate?.updateOrderProfile()
        currentPage += 1
        
        guard currentPage == 3 else { return }
        submitOrder()

//        if formValid.isValid {
//            delegate?.updateOrderProfile()
//            currentPage += 1
//            
//            guard currentPage == 3 else { return }
//            submitOrder()
//        } else {
//            guard let message = formValid.message else { return }
//            Alert.showAlert(message: message, alertType: .okOnly, header: nil, viewController: self)
//        }
        

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
            self.orderController.submitOrder(order: order, completion: { (completed) in
                DispatchQueue.main.async {
                    self.hideProgressHUD()
                    guard completed else { return }
                    
                    let cartController = CartController()
                    cartController.deleteAllCarts()

                    let storyboard = UIStoryboard(name: Constants.storyboard.order, bundle: nil)
                    guard let vc = storyboard.instantiateViewController(withIdentifier: Constants.viewController.order.note) as? OrderNoteViewController else { return }
                    self.pushNavigation(targetVC: vc)
                    
                }
            })
        }
        
    }
}
