//
//  ProductConfirmationViewController.swift
//  MCommerce
//
//  Created by Ambar Septian on 6/28/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit
import Iconic

class ProductConfirmationViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var closeButton: BasicButton! {
        didSet {
            let iconString = FontAwesomeIcon.removeIcon.attributedString(ofSize: 25 , color: Color.orange)
            closeButton.setAttributedTitle(iconString, for: .normal)
        }
    }
    
    
    @IBOutlet weak var collectionView: TagCollectionView!
    
    @IBOutlet weak var quantityLabel: UILabel! {
        didSet {
            quantityLabel.text = "quantity".localize
        }
    }
    
    @IBOutlet weak var stepper: RoundedStepper! {
        didSet {
            stepper.counter = 1
            stepper.delegate = self
        }
    }
    
    @IBOutlet weak var stockLabel: RoundedLabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var addToCartButton: BasicButton! {
        didSet {
            addToCartButton.setTitleColor(Color.lightGray, for: .disabled)
            addToCartButton.setTitleColor(Color.orange, for: .normal)
        }
    }
    
  
    @IBOutlet weak var collectionViewConstraint: NSLayoutConstraint!
    
    lazy var dismissGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(self.closeButtonTapped(_:)))
        gesture.delegate = self
        
        return gesture
    }()
    
    var passedProduct: Product?
    
    fileprivate var variants: [ProductVariant] {
        return passedProduct?.variants ?? [ProductVariant]()
    }
    
    
    
    fileprivate var currentSelectedIndex: Int = 0 {
        didSet {
            guard currentSelectedIndex != oldValue else { return }
            updateStockLabel()
        }
    }
    
    fileprivate let gestureTag = 98
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addGestureRecognizer(dismissGesture)
        automaticallyAdjustsScrollViewInsets = true
        
        navigationController?.navigationBar.isUserInteractionEnabled = false
        loadProduct()

        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard keyPath == "contentSize" else { return }
        collectionViewConstraint.constant = collectionView.contentSize.height * 1.5
    }
    
    deinit {
        collectionView.removeObserver(self, forKeyPath: "contentSize")
    }
    
}


extension ProductConfirmationViewController {
    func loadProduct(){
        guard let product = passedProduct else { return }
        nameLabel.text = product.name
        priceLabel.text = product.formattedPrice
        collectionView.reloadData()
        collectionView.addObserver(self, forKeyPath: "contentSize", options: [], context: nil)
        updateStockLabel()
    }
    
   
    func updateStockLabel(){
        let variant = variants[currentSelectedIndex]
        stockLabel.text = "stock".localize + ": " +  String(variant.stock)
        
        if stepper.counter <= variant.stock {
            stockLabel.mainColor = Color.green
            addToCartButton.isEnabled = true
        } else {
            stockLabel.mainColor = Color.red
            addToCartButton.isEnabled = false
        }
    }
}

extension ProductConfirmationViewController {
    @IBAction func addToCartButtonTapped(_ sender: Any) {
        guard let product = passedProduct else { return }
        let cartController = CartController()
//        showProgressHUD()
        DispatchQueue.global().async {
            cartController.addToCart(product: product, quantity: self.stepper.counter, completion: { (completed) in
                DispatchQueue.main.async {
                    guard completed else { return }
                    
                    TabBarBadge.shared.cartCount += 1
                    Alert.showAlert(message: "addToCartSuccess".localize, alertType: .okOnly, header: nil, viewController: self, handler: { (alert) in
                        self.closeButtonTapped(self)
                    })
                    
                }
                
            })
        }
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        presentingViewController?.navigationController?.navigationBar.isUserInteractionEnabled = true
        dismiss(animated: true, completion: nil)
    }
}

extension ProductConfirmationViewController {
    static func showViewController(currentVC:UIViewController, product: Product){
        let storyboard = UIStoryboard(name: Constants.storyboard.product, bundle: nil)
        guard let confirmationVC = storyboard.instantiateViewController(withIdentifier: Constants.viewController.product.confirmation) as? ProductConfirmationViewController else { return }
        confirmationVC.passedProduct = product
        confirmationVC.modalTransitionStyle = .crossDissolve
        confirmationVC.modalPresentationStyle = .overCurrentContext
        confirmationVC.view.backgroundColor = Color.darkGray.withAlphaComponent(0.7)
        currentVC.navigationController?.navigationBar.isUserInteractionEnabled = false
//        let navigationController = UINavigationController(rootViewController: confirmationVC)
        currentVC.present(confirmationVC, animated: true, completion: nil)
    }
}

extension ProductConfirmationViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return variants.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let variant = variants[indexPath.row]
        let cell = TagCollectionViewCell.configureCell(collectionView: collectionView, indexPath: indexPath, object: variant) as! TagCollectionViewCell
        
        if indexPath.row == currentSelectedIndex {
            cell.setAppreanceCell(isActive: true)
        }
        
        return cell
    }
}


extension ProductConfirmationViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.row != currentSelectedIndex  else { return }
        
        let previousIndexPath = IndexPath(row: currentSelectedIndex, section: indexPath.section)
        guard let deActiveCell = collectionView.cellForItem(at: previousIndexPath) as? TagCollectionViewCell else { return }
        deActiveCell.setAppreanceCell(isActive: false)
        
        currentSelectedIndex = indexPath.row
        guard let activeCell = collectionView.cellForItem(at: indexPath) as? TagCollectionViewCell else { return }
        activeCell.setAppreanceCell(isActive: true)
    }
}

extension ProductConfirmationViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let gesturePoint  = gestureRecognizer.location(in: self.view)
        guard let viewTouched = self.view.hitTest(gesturePoint, with: nil) else { return false }
        return viewTouched.tag == gestureTag ? true : false
    }
}

extension ProductConfirmationViewController: RoundedStepperDelegate {
    func stepperValueDidUpdate(value: Int) {
        guard let product = passedProduct else { return }
        priceLabel.text = (Double(value) * product.price).formattedPrice
        updateStockLabel()
    }
}
