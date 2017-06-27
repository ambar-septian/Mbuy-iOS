//
//  FirebaseProtocol.swift
//  MCommerce
//
//  Created by Ambar Septian on 6/27/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import Foundation
import FirebaseDatabase

protocol FirebaseProtocol: class {
    var key: String { get }
    var ref: FIRDatabaseReference? { get set }

}
