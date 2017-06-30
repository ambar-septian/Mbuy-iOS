//
//  ProductController.swift
//  MCommerce
//
//  Created by Ambar Septian on 6/27/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import Foundation
import Firebase

typealias productsCompletion = ((_ products: [Product]) -> Void)

class ProductController {
    
    fileprivate let ref = FIRDatabase.database().reference(withPath: "products")
    fileprivate let limitRelated = 5
    fileprivate let maxLimitRelated = 15
    
    func loadProductByCategory(categoryID:String, completion: @escaping productsCompletion){
        ref.queryOrdered(byChild: Product.jsonKeys.category).queryStarting(atValue: categoryID).queryEnding(atValue: categoryID).observe(.value, with: { snapshot in
            var products: [Product] = []
            
            for item in snapshot.children {
                let product = Product(snapshot: item as! FIRDataSnapshot)
                products.append(product)
            }
            
            completion(products)
        })
    }
    
    func loadRelatedProducts(categoryID:String, completion: @escaping productsCompletion){
        ref.queryOrdered(byChild: Product.jsonKeys.category).queryStarting(atValue: categoryID).queryEnding(atValue: categoryID).queryLimited(toFirst: UInt(maxLimitRelated)).observe(.value, with: { snapshot in
            var products: [Product] = []
            
            for item in snapshot.children {
                let product = Product(snapshot: item as! FIRDataSnapshot)
                products.append(product)
            }
            
            for _ in 0 ..< self.limitRelated {
                guard products.count > self.limitRelated else { break }
                let randomIndex = Int(arc4random_uniform(UInt32(products.count)))
                products.remove(at: randomIndex)
            }
            completion(products)
        })
    }

}
