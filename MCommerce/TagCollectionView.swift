//
//  TagCollectionView.swift
//  MCommerce
//
//  Created by Ambar Septian on 6/15/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit

class TagCollectionView: UICollectionView {
    override var dataSource: UICollectionViewDataSource? {
        didSet {
            reloadData()
        }
    }
    
   
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setupCollectionView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupCollectionView()
    }
    
    func setupCollectionView(){
        let cell = TagCollectionViewCell.self
        register(cell.nib, forCellWithReuseIdentifier: cell.identifier)
        backgroundColor = Color.cream
        layer.cornerRadius = Constants.cornerRadius
        
    }
}

extension TagCollectionView: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
////        self.configureCell(self.sizingCell!, forIndexPath: indexPath)
////        return self.sizingCell!.systemLayoutSizeFittingSrize(UILayoutFittingCompressedSize)
//    }
}

class TagFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var newAttributesForElementsInRect = [UICollectionViewLayoutAttributes]()
        
        guard let attributesForElementsInRect = super.layoutAttributesForElements(in: rect) else {
            return newAttributesForElementsInRect
        }
        
        var leftMargin: CGFloat = 0
        for attributes in attributesForElementsInRect {
            let refAttributes = attributes
        
            if (refAttributes.frame.origin.x == self.sectionInset.left) {
                leftMargin = self.sectionInset.left
            } else {
                
                var newLeftAlignedFrame = refAttributes.frame
                newLeftAlignedFrame.origin.x = leftMargin
                refAttributes.frame = newLeftAlignedFrame
            }
            // calculate new value for current margin
            leftMargin += refAttributes.frame.size.width
            newAttributesForElementsInRect.append(refAttributes)
        }
        return newAttributesForElementsInRect
    }
}

class TagCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    var tags: [ProductTag]
    
    init(tags: [ProductTag]) {
        self.tags = tags
        super.init()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return TagCollectionViewCell.configureCell(collectionView: collectionView, indexPath: indexPath, object: tags[indexPath.item])
    }
}

class TagCollectionViewDelegate: NSObject, UICollectionViewDelegate {
    override init(){
        super.init()
    }
    
    
}
