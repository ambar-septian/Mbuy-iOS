//
//  DynamicColllectionViewLayout.swift
//  MCommerce
//
//  Created by Ambar Septian on 5/24/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit

class DynamicCollectionViewLayout: UICollectionViewLayout {
    weak var delegate: DynamicCollectionViewLayoutDelegate!
    
    var numberOfColumns = 2
    
    var cellPadding:CGFloat =  2
    
    private var cache = [DynamicCollectionLayoutAttributes]()
    
    private var contentHeight:CGFloat = 0
    
    private var contentWidth:CGFloat {
        let insets = collectionView!.contentInset
        return collectionView!.bounds.width - (insets.left + insets.right)
    }
    
    override func prepare(){
        guard cache.isEmpty else { return }
        
        let columnWidth = contentWidth / CGFloat(numberOfColumns) + cellPadding
        var xOffset = [CGFloat]()
        
        for column in 0 ..< numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        
        var column = 0
        var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)
        
        
        for item in 0 ..< collectionView!.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            
            let width = columnWidth - (cellPadding * 2)
            let imageHeight = delegate.collectionView(collectionView: collectionView!, heightForImageAtIndexPath: indexPath, withWidth: width)
            
            let annotationHeight = delegate.collectionView(collectionView: collectionView!, heightForAnnotationAtIndexPath: indexPath, withWidth: width)
            
            let height =  imageHeight + annotationHeight + (cellPadding * 2)
            let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
            
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            let attributes = DynamicCollectionLayoutAttributes(forCellWith: indexPath)
            attributes.imageHeight = imageHeight
            
            attributes.frame = insetFrame
            cache.append(attributes)
            
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] += height
            
            column = column >= (numberOfColumns - 1) ? 0 : column + 1
            
            
        }
        
    }
    
    override class var layoutAttributesClass:  AnyClass {
        return DynamicCollectionLayoutAttributes.self
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width:contentWidth, height: contentHeight)
    }
    
    override func invalidateLayout() {
        cache.removeAll()
        super.invalidateLayout()
        
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for attributes in cache {
            guard attributes.frame.intersects(rect) else { continue }
            layoutAttributes.append(attributes)
        }
        
        return layoutAttributes
    }
}


class DynamicCollectionLayoutAttributes : UICollectionViewLayoutAttributes {
    var imageHeight:CGFloat = 0
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! DynamicCollectionLayoutAttributes
        copy.imageHeight = imageHeight
        return copy
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let attributes = object as? DynamicCollectionLayoutAttributes else {
            return false
        }
        
        if attributes.imageHeight == imageHeight {
            return super.isEqual(object)
        }
        
        return false
    }
}

protocol DynamicCollectionViewLayoutDelegate:class {
    func collectionView(collectionView: UICollectionView, heightForImageAtIndexPath indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat
    func collectionView(collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat
}

