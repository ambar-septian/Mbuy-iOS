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
    
    @IBOutlet weak var reviewTableView: UITableView!{
        didSet {
            let cell = ReviewTableViewCell.self
            reviewTableView.register(cell.nib, forCellReuseIdentifier: cell.identifier)
            
        }
    }
    
    @IBOutlet weak var addToCartButton: CircleImageButton! {
        didSet {
            addToCartButton.icon = .shoppingCartIcon
            addToCartButton.mainColor = Color.orange
        }
    }
    
    @IBOutlet weak var shareButton: CircleImageButton! {
        didSet {
            shareButton.icon = .uniF1E0Icon
            shareButton.mainColor = Color.orange
        }
    }
    
    
    @IBOutlet weak var seeMoreButton: UIButton!
    
    @IBOutlet weak var reviewLabel: UILabel!
    
    @IBOutlet weak var relatedItemsLabel: UILabel!
    
    @IBOutlet weak var descriptionHeadingLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var stockLabel: RoundedLabel! {
        didSet {
            stockLabel.mainColor = Color.green
        }
    }
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var reviewEmptyLabel: UILabel!
    
    @IBOutlet weak var ratingView: RatingStarsView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var constraintDetailTableView: NSLayoutConstraint!
    
    @IBOutlet weak var constraintReviewTableView: NSLayoutConstraint!
    
    
    var passedProduct: Product?
    
    fileprivate var product: Product? {
        didSet {
            guard let product = self.product else { return }
            nameLabel.text = product.name
            priceLabel.text = product.formattedPrice
            dateLabel.text = product.formattedCreatedDate
            ratingView.numberOfStars = product.rating
            descriptionLabel.text = product.description
            stockLabel.text = product.formattedStock
            passedProduct = nil
        }
    }
    
    fileprivate var productDetails: [ProductDetail] {
        get {
            return product?.details ?? [ProductDetail]()
        }
        
        set {
            product?.details = newValue
            detailTableView.reloadData()
            constraintDetailTableView.constant = detailTableView.contentSize.height
        }
        
    }
    
    fileprivate var productImageURLs: [String] {
        get {
            return product?.imageURLs ?? [String]()
        }
        
        set {
            pageControl.numberOfPages = newValue.count
            product?.imageURLs = newValue
            productsCollectionView.reloadData()
        }
    }
    
    
    fileprivate var reviews = [Review]() {
        didSet {
            reviewTableView.reloadData()
            reviewEmptyLabel.isHidden = !(reviews.isEmpty)
            constraintReviewTableView.constant = reviewTableView.contentSize.height
        }
    }
    
    fileprivate var relatedProducts = [Product]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // call didset
//        product = passedProduct
        passedProduct = nil
        
        let category = Category(categoryID: "1", name: "a", imageURL: "")
        product = Product(productID: "1", name: "Sepatu Nike", category: category, imageURL: "https://images-eu.ssl-images-amazon.com/images/G/31/img15/Shoes/CatNav/k._V293117556_.jpg", stock: 30, description: "In a storyboard-based application, you will often want to do a", price: 50000, createdDate: Date())
        
        let user = User(email: "", firstName: "Ponim", lastName: "Kirun", address: "Tomang", userType: .email, profileImagePath: "https://dummyimage.com/600x400/000/fff")
        let user2 = User(email: "", firstName: "Riri", lastName: "Tamam", address: "Tebet", userType: .email, profileImagePath: "https://api.adorable.io/avatars/114/happy@adorable.io.png")
        let user3 = User(email: "", firstName: "Ires", lastName: "Pitri", address: "Palmerah", userType: .email, profileImagePath: "https://dummyimage.com/600x400/000/fff")
        let review = Review(reviewID: "1", title: "Good", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua", rating: 5, product: product!, user: user, date: Date())
        let review2 = Review(reviewID: "1", title: "Good", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua", rating: 4, product: product!, user: user2, date: Date())
        let review3 = Review(reviewID: "1", title: "Good", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua", rating: 3, product: product!, user: user3, date: Date())
        
        reviews = [review, review2, review3]
        
        let detail = ProductDetail(field: "Category", value: "Shoes")
        let detail2 = ProductDetail(field: "Model", value: "Red Shoes")
        let detail3 = ProductDetail(field: "Size", value: "12 cm x 5 cm")
        let detail4 = ProductDetail(field: "Weight", value: "0.2 kg")
        
        productDetails = [detail, detail2, detail3, detail4]
        
        let product1 = Product(productID: "1", name: "Sepatu Nike", category: category, imageURL: "https://images-eu.ssl-images-amazon.com/images/G/31/img15/Shoes/CatNav/k._V293117556_.jpg", stock: 30, description: "In a storyboard-based application, you will often want to do a", price: 50000, createdDate: Date())
        let product2 = Product(productID: "1", name: "Jacket Nike", category: category, imageURL: "http://www.thinkgeek.com/images/products/zoom/jouj_sw_tie_pilot_leather_ladies_jacket_jacket.jpg", stock: 30, description: "In a storyboard-based application, you will often want to do a", price: 50000, createdDate: Date())
        let product3 = Product(productID: "1", name: "Watch", category: category, imageURL: "https://cdn.shopify.com/s/files/1/0377/2037/products/WhiteGoldLeather.Front_large.jpg?v=1490307659", stock: 30, description: "In a storyboard-based application, you will often want to do a", price: 50000, createdDate: Date())
        let product4 = Product(productID: "1", name: "Tas", category: category, imageURL: "http://id-live-02.slatic.net/p/7/quincy-label-eve-tote-bag-bonus-tas-kecil-hitam-1729-6012889-7f0b3d99fef9dd3faa34c604c29407ce.jpg", stock: 30, description: "In a storyboard-based application, you will often want to do a", price: 50000, createdDate: Date())
        
        relatedProducts = [product1, product2, product3, product4, product1, product2, product3, product4]
        productImageURLs = ["http://id-live-02.slatic.net/p/7/quincy-label-eve-tote-bag-bonus-tas-kecil-hitam-1729-6012889-7f0b3d99fef9dd3faa34c604c29407ce.jpg", "https://cdn.shopify.com/s/files/1/0377/2037/products/WhiteGoldLeather.Front_large.jpg?v=1490307659"]
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ProductDetailViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == detailTableView {
            return productDetails.count
        } else {
            return reviews.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == detailTableView {
            let productDetail = productDetails[indexPath.row]
            return ProductDetailTableViewCell.configureCell(tableView: tableView, indexPath: indexPath, object: productDetail)
        } else {
            let review = reviews[indexPath.row]
            return ReviewTableViewCell.configureCell(tableView: tableView, indexPath: indexPath, object: review)
        }
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
            return ProductImageCollectionViewCell.configureCell(collectionView: collectionView, indexPath: indexPath, object: productImage)
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
            guard let cell = collectionView.cellForItem(at: indexPath) as? ProductImageCollectionViewCell else { return }
            vc.passedImage = cell.productImageView.image
            present(vc, animated: true, completion: nil)
        } else {
            guard let vc = storyboard.instantiateViewController(withIdentifier: Constants.viewController.product.detail) as? ProductDetailViewController else { return }
            pushNavigation(targetVC: vc)
        }
    }
}

extension ProductDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == productsCollectionView {
            return collectionView.bounds.size
        } else {
            let padding = collectionView.bounds.width * 0.15
            let size = CGSize(width: collectionView.bounds.width / 2 - padding, height: collectionView.bounds.height)
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


