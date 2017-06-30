//
//  CategoryController.swift
//  MCommerce
//
//  Created by Ambar Septian on 6/27/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import Foundation
import FirebaseDatabase

typealias categoriesCompletion = ((_ categories: [Category]) -> Void)

var CurrentCategories = [Category]()

class CategoryController {
    
    fileprivate let ref = FIRDatabase.database().reference(withPath: "categories")
    
    func loadCategories(completion: @escaping categoriesCompletion){
        ref.queryOrdered(byChild: Category.jsonKeys.orderNumber).observe(.value, with: { snapshot in
            var categories: [Category] = []
            
            for item in snapshot.children {
                let category = Category(snapshot: item as! FIRDataSnapshot)
                categories.append(category)
            }
            
            completion(categories)
        })
    }
    

}
