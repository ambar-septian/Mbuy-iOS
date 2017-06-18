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
    


    override func viewDidLoad() {
        super.viewDidLoad()

        let category = Category(categoryID: "1", name: "a", imageURL: "")
        let product1 = Product(productID: "1", name: "Sepatu Nike", category: category, imageURL: "https://images-eu.ssl-images-amazon.com/images/G/31/img15/Shoes/CatNav/k._V293117556_.jpg", stock: 30, description: "In a storyboard-based application, you will often want to do a", price: 50000, createdDate: Date())
        let product2 = Product(productID: "1", name: "Jacket Nike", category: category, imageURL: "http://www.thinkgeek.com/images/products/zoom/jouj_sw_tie_pilot_leather_ladies_jacket_jacket.jpg", stock: 30, description: "In a storyboard-based application, you will often want to do a", price: 50000, createdDate: Date())
        let product3 = Product(productID: "1", name: "Watch", category: category, imageURL: "https://cdn.shopify.com/s/files/1/0377/2037/products/WhiteGoldLeather.Front_large.jpg?v=1490307659", stock: 30, description: "In a storyboard-based application, you will often want to do a", price: 50000, createdDate: Date())
        let product4 = Product(productID: "1", name: "Tas", category: category, imageURL: "http://id-live-02.slatic.net/p/7/quincy-label-eve-tote-bag-bonus-tas-kecil-hitam-1729-6012889-7f0b3d99fef9dd3faa34c604c29407ce.jpg", stock: 30, description: "In a storyboard-based application, you will often want to do a", price: 50000, createdDate: Date())
        
        products = [product1, product2, product3, product4, product1, product2, product3, product4]
        // Do any additional setup after loading the view.
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

extension ProductListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let product = products[indexPath.item]
        return ProductCollectionViewCell.configureCell(collectionView: collectionView, indexPath: indexPath, object: product)
    }
}

extension ProductListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         performSegue(withIdentifier: Constants.segueID.showProductDetail, sender: indexPath.item)
        print("select")
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
//        let font = Font.semiBold.withSize(15)
//        
//        let tagNameHeight = tagStations[indexPath.item].tagName.heightBasedFont(width: width, font: font)
//        let introduceHeight = tagStations[indexPath.item].playlist.introduce.heightBasedFont(width: width, font: font)
//        return CGFloat(tagNameHeight + introduceHeight + 20)
        guard let cell = collectionView.cellForItem(at: indexPath) as? ProductCollectionViewCell else {
            return 160
        }
        let height = cell.frame.height - cell.imageView.frame.height
        return height
    }
}

