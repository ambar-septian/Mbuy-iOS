//
//  SearchController.swift
//  MCommerce
//
//  Created by Ambar Septian on 7/4/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import Foundation
import FirebaseDatabase

typealias searchResultsCompletion = ((_ searchResults: [SearchResult]) -> Void)

protocol SearchProductDelegate:class {
    func refreshFilterProduct()
}

class SearchController {
    fileprivate let productRef = FIRDatabase.database().reference(withPath: "products")
    fileprivate let searchRef = FIRDatabase.database().reference(withPath: "searchlist")
    fileprivate var searchHandler: UInt?
    fileprivate var searchResults = [SearchResult]()
    fileprivate var filterResults = [SearchResult]()
    var products = [Product]()
    
    var minimumKeywordLength = 3
    
    weak var delegate: SearchProductDelegate?
    
    var keyword:String? {
        didSet {
            guard let wKeyword = keyword else {
                removeProducts()
                return
            }
            guard wKeyword.characters.count >= minimumKeywordLength else {
                removeProducts()
                return }
            filterResults = searchResults.filter({ $0.name.lowercased().contains(wKeyword.lowercased()) })
            guard filterResults.count > 0 else {
                removeProducts()
                return
            }
            products.removeAll()
            searchProduct()
        }
    }
//    fileprivate var searchRef: FIRDatabaseReference?
    
    fileprivate func searchProduct(indexFilter: Int = 0){
        guard filterResults.count - 1 >= indexFilter else { return }
        let productID = filterResults[indexFilter].key
        
        productRef.child(productID).observeSingleEvent(of: .value, with: { (snapshot) in
            let product = Product(snapshot: snapshot)
            self.products.append(product)
            
            if indexFilter == self.filterResults.count - 1 {
                self.delegate?.refreshFilterProduct()
            } else {
                self.searchProduct(indexFilter: indexFilter + 1)
            }
            
            
        })
    }
    
    fileprivate func removeProducts(){
        products.removeAll()
        delegate?.refreshFilterProduct()
    }
   
    func removeSearchHandler(){
        guard let handler = searchHandler else { return }
        productRef.removeObserver(withHandle: handler)
    }
    
    func getSearchList(completion: @escaping finishCompletion){
        searchRef.observeSingleEvent(of: .value, with: { (snapshots) in
            self.searchResults.removeAll()
            var searchResults: [SearchResult] = []
            
            for item in snapshots.children {
                let searchResult = SearchResult(snapshot: item as! FIRDataSnapshot)
                searchResults.append(searchResult)
            }
            self.searchResults = searchResults
            completion(true)
        }) { (error) in
            print(error.localizedDescription)
            completion(false)
        }
    }

}
