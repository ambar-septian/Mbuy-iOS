//
//  ProductDetailViewController.swift
//  MCommerce
//
//  Created by Ambar Septian on 6/13/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit
import Iconic

class ProductDetailViewController: BaseViewController {

    @IBOutlet weak var productsCollectionView: UICollectionView! {
        didSet {
            let cell = ProductImageCollectionViewCell.self
            productsCollectionView.register(cell, forCellWithReuseIdentifier: cell.identifier)
            productsCollectionView.heroID = Constants.heroID.productThumbnail
        }
    }
    
    @IBOutlet weak var relatedCollectionView: UICollectionView! {
        didSet {
            let cell = SimpleProductCollectionViewCell.self
            relatedCollectionView.register(cell.nib, forCellWithReuseIdentifier: cell.identifier)
        }
    }
    
    @IBOutlet weak var detailTableView: UITableView!{
        didSet {
            let cell = ProductDetailTableViewCell.self
            detailTableView.register(cell.nib, forCellReuseIdentifier: cell.identifier)
        }
    }
  
    @IBOutlet weak var addToCartButton: CircleImageButton! {
        didSet {
            addToCartButton.icon = .shoppingCartIcon
            addToCartButton.mainColor = Color.orange
        }
    }
    
   
    
    @IBOutlet weak var seeMoreButton: UIButton!
    
    @IBOutlet weak var reviewLabel: UILabel!
    
    @IBOutlet weak var relatedItemsLabel: UILabel!
    
    @IBOutlet weak var descriptionHeadingLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var stockLabel: RoundedLabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var reviewEmptyLabel: UILabel! {
        didSet {
            reviewEmptyLabel.isHidden = true
        }
    }
    
    @IBOutlet weak var ratingView: RatingStarsView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var constraintDetailTableView: NSLayoutConstraint!
    
    
    
    var passedProduct: Product?
    
    fileprivate var controller = ProductController()
    
    fileprivate var productDetails: [ProductDetail] {
        get {
            return passedProduct?.details ?? [ProductDetail]()
        }
        
        set {
            passedProduct?.details = newValue
            detailTableView.reloadData()
            constraintDetailTableView.constant = detailTableView.contentSize.height
        }
        
    }
    
    fileprivate var productImageURLs: [String] {
        get {
            return passedProduct?.imageURLs ?? [String]()
        }
        
        set {
            pageControl.numberOfPages = newValue.count
            passedProduct?.imageURLs = newValue
            productsCollectionView.reloadData()
        }
    }
    
    

    
    fileprivate var relatedProducts = [Product]() {
        didSet {
            relatedCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        definesPresentationContext = true
        loadProduct()
        loadRelatedProducts()
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        let confirmationVC = ProductConfirmationViewController.self
//        confirmationVC.showViewController(currentVC: self, product: passedProduct!)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func addToCartButtonTapped(_ sender: Any) {
        guard let product = self.passedProduct else { return }
        let confirmationVC = ProductConfirmationViewController.self
        confirmationVC.showViewController(currentVC: self, product: product)
    }
}

extension ProductDetailViewController {
    fileprivate func loadProduct(){
        guard let product = passedProduct else { return }
        
        navigationItem.title = product.name
        nameLabel.text = product.name
        priceLabel.text = product.formattedPrice
        dateLabel.text = product.formattedCreatedDate
        ratingView.numberOfStars = product.rating
        descriptionLabel.text = product.description
        stockLabel.text = product.formattedStock
        stockLabel.mainColor = product.stock > 0 ? Color.green : Color.red
        stockLabel.updateConstraints()
        
        productDetails = product.details
        productImageURLs = product.imageURLs

    }
    
    fileprivate func loadRelatedProducts() {
        guard let product = passedProduct else { return }
        guard let category = product.category else { return }
        DispatchQueue.global().async {
            self.controller.loadProductByCategory(categoryID: category.categoryID, completion: { (products) in
                DispatchQueue.main.async {
                    self.relatedProducts = products.filter({ $0.productID != product.productID })
                }
            })
        }
        
    }
}

extension ProductDetailViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let productDetail = productDetails[indexPath.row]
        return ProductDetailTableViewCell.configureCell(tableView: tableView, indexPath: indexPath, object: productDetail)
    }
}

extension ProductDetailViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == detailTableView {
            return 44
        } else {
            return 170
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == detailTableView {
            
        } else {
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
}


extension ProductDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == productsCollectionView {
            return productImageURLs.count
        } else {
            return relatedProducts.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == productsCollectionView {
            let productImage = productImageURLs[indexPath.item]
            let cell = ProductImageCollectionViewCell.configureCell(collectionView: collectionView, indexPath: indexPath, object: productImage) as! ProductImageCollectionViewCell
            cell.productImageView.alignTop = (passedProduct?.category?.isClothing ?? false) ? true : false
            return cell
        } else {
            let product = relatedProducts[indexPath.item]
            return SimpleProductCollectionViewCell.configureCell(collectionView: collectionView, indexPath: indexPath, object: product)
        }
    }
    
    
    
}

extension ProductDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: Constants.storyboard.product, bundle: nil)
        if collectionView == productsCollectionView {
            guard let vc = storyboard.instantiateViewController(withIdentifier: Constants.viewController.product.preview) as? ProductPreviewViewController else { return }
            vc.passedImageURLs = productImageURLs
            vc.passedSelectedIndex = indexPath.row
            vc.view.backgroundColor = Color.darkGray.withAlphaComponent(0.7)
            vc.modalTransitionStyle = .crossDissolve
            let nav = UINavigationController(rootViewController: vc)
            present(nav, animated: true, completion: nil)
        } else {
            guard let vc = storyboard.instantiateViewController(withIdentifier: Constants.viewController.product.detail) as? ProductDetailViewController else { return }
            vc.passedProduct = relatedProducts[indexPath.row]
            pushNavigation(targetVC: vc)
        }
    }
}

extension ProductDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == productsCollectionView {
            return CGSize(width: view.bounds.width, height: collectionView.bounds.height)
        } else {
            let padding = collectionView.bounds.width * 0.15
            let size = CGSize(width: collectionView.bounds.width / 1.7 - padding, height: collectionView.bounds.height)
            return size
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == productsCollectionView {
            return 1
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == productsCollectionView {
            return 1
        } else {
            return 1
        }
    }
}

extension ProductDetailViewController {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView == productsCollectionView else { return }
        let index = Int(round(productsCollectionView.contentOffset.x / productsCollectionView.frame.width))
        pageControl.currentPage = index
    }
}


