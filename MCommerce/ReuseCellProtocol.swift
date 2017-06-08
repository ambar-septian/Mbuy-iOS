//
//  ReuseCellProtocol.swift
//  MCommerce
//
//  Created by Ambar Septian on 5/24/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit

protocol ReuseCellProtocol {}
extension ReuseCellProtocol {
    static var identifier: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
}


protocol ReuseTableCellProtocol: ReuseCellProtocol {
    static func configureCell<T>(tableView: UITableView, indexPath:IndexPath, object: T?) -> UITableViewCell
}

protocol ReuseCollectionCellProtocol: ReuseCellProtocol {
    static func configureCell<T>(collectionView: UICollectionView, indexPath:IndexPath, object: T?) -> UICollectionViewCell
}


