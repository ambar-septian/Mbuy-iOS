//
//  SearchResult.swift
//  MCommerce
//
//  Created by Ambar Septian on 7/4/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import Foundation
import FirebaseDatabase

class SearchResult:FirebaseProtocol {
    var name:String
    var key:String
    var ref: FIRDatabaseReference?

    static let jsonKey:String = "name"
    
    init(snapshot: FIRDataSnapshot) {
        self.key = snapshot.key
        
        let snapshotValue = snapshot.value as! [String: AnyObject]
        self.name  = snapshotValue[SearchResult.jsonKey] as? String ?? ""
        ref = snapshot.ref
    }
}

extension SearchResult: Hashable {
    var hashValue:Int {
        return Int(key) ?? 0
    }
}

extension SearchResult: Equatable {
    static func ==(lhs:SearchResult, rhs:SearchResult) -> Bool{
        return lhs.key == rhs.key
    }
}

