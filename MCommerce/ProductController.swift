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
}
