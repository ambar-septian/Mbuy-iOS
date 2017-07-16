//
//  ProductListViewController.swift
//  MCommerce
//
//  Created by Ambar Septian on 5/23/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit
import AVFoundation
import Anchorage

class ProductListViewController: BaseViewController {
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            let cell = ProductCollectionViewCell.self
            collectionView.register(cell.nib, forCellWithReuseIdentifier: cell.identifier)
            guard let layout = collectionView.collectionViewLayout as? DynamicCollectionViewLayout else { return }
            layout.delegate = self
        }
    }
    
    var products = [Product]() {
        didSet {
            collectionView.reloadData()

//            collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    fileprivate let controller = ProductController()
    
    fileprivate lazy var emptyView: EmptyDataView =  {
        let view = EmptyDataView(frame: self.view.bounds)
        view.image = #imageLiteral(resourceName: "bag")
        view.title = "emptyProductCategory".localize
        
        return view
    }()
    
    
    var passedCategory: Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
        
        loadProducts()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.segueID.showProductDetail {
            guard let vc = segue.destination as? ProductDetailViewController else { return }
            guard let index = sender as? Int else { return }
            vc.passedProduct = products[index]
        }
    }

}

extension ProductListViewController {
    func loadProducts(){
        if passedCategory != nil {
            loadProductByCategories()
        }
    }
    
    fileprivate func loadProductByCategories(){
        guard let category = passedCategory else { return }
        self.navigationItem.title = category.name
        showProgressHUD()
        DispatchQueue.global().async {
            self.controller.loadProductByCategory(categoryID: category.categoryID, completion: { (products) in
                DispatchQueue.main.async {
                    self.hideProgressHUD()
                    self.products = products
                    
                    let willHide = products.count > 0 ? true: false
                    self.emptyView.toggleHide(willHide: willHide)

                }
            })
        }
    }
}

extension ProductListViewController:BaseViewProtocol {
    func setupSubviews() {
        view.addSubview(emptyView)
        setupConstraints()
    }
    
    func setupConstraints() {
         emptyView.edgeAnchors == self.view.edgeAnchors
    }
}

extension ProductListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let product = products[indexPath.item]
        let cell =  ProductCollectionViewCell.configureCell(collectionView: collectionView, indexPath: indexPath, object: product) as! ProductCollectionViewCell
        cell.currentVC = self
        
        return cell
    }
}

extension ProductListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         performSegue(withIdentifier: Constants.segueID.showProductDetail, sender: indexPath.item)
        print("select")
    }
    
    func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        return false
    }
}


extension ProductListViewController: DynamicCollectionViewLayoutDelegate {
    func collectionView(collectionView: UICollectionView, heightForImageAtIndexPath indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat {
        
        guard let imageSize =  products[indexPath.item].imageSize else {
            return collectionView.frame.width * 0.5
        }
        
        let boundingRect = CGRect(origin: CGPoint.zero, size: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))
        let rect = AVMakeRect(aspectRatio: imageSize, insideRect: boundingRect)
        
        return rect.height
        
    }
    
    func collectionView(collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat {
        let padding:CGFloat = 120
        let product = products[indexPath.row]
        let nameHeight = product.name.heightBasedFont(width: width, font: Font.latoRegular.withSize(17))
        let priceHeight = product.formattedPrice.heightBasedFont(width: width, font: Font.latoBold.withSize(16))
        
        return nameHeight + priceHeight + padding
    }
    
}

