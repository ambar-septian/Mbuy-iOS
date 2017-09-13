//
//  ProductPreviewCollectionViewCell.swift
//  MCommerce
//
//  Created by Ambar Septian on 8/6/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit

class ProductPreviewCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
            scrollView.maximumZoomScale = 3
//            scrollView.panGestureRecognizer.allowedTouchTypes = [ NSNumber(value:UITouchType.indirect.rawValue) ]
            scrollView.translatesAutoresizingMaskIntoConstraints = true
            scrollView.frame = self.bounds
            scrollView.contentMode = .center
            
        }
    }
    
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.translatesAutoresizingMaskIntoConstraints = true
            imageView.frame = self.bounds
        }
    }
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    
    lazy var doubleTapGesture: UITapGestureRecognizer = {
         let gesture = UITapGestureRecognizer(target: self, action: #selector(self.doubleTapGestureAction(sender:)))
        gesture.numberOfTapsRequired = 2
        
        return gesture
    }()
    
    var topInset: CGFloat = 0 {
        didSet {
            centerIfNeeded()
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //        updateConstraintsForSize(size: bounds.size)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.frame = bounds
        let size: CGSize
        if let image = imageView.image {
            let containerSize = CGSize(width: bounds.width, height: bounds.height - topInset)
            if containerSize.width / containerSize.height < image.size.width / image.size.height {
                size = CGSize(width: containerSize.width, height: containerSize.width * image.size.height / image.size.width )
            } else {
                size = CGSize(width: containerSize.height * image.size.width / image.size.height, height: containerSize.height )
            }
        } else {
            size = CGSize(width: bounds.width, height: bounds.width)
        }
        imageView.frame = CGRect(origin: .zero, size: size)
        scrollView.contentSize = size
        centerIfNeeded()
    }
    

}

extension ProductPreviewCollectionViewCell {
    func doubleTapGestureAction(sender: UITapGestureRecognizer) {
        if scrollView.zoomScale == 1 {
            scrollView.zoom(to: zoomRectForScale(scale: scrollView.maximumZoomScale, center: sender.location(in: sender.view)), animated: true)
        } else {
            scrollView.setZoomScale(1, animated: true)
        }

    }
    
    func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = imageView.frame.size.height / scale
        zoomRect.size.width  = imageView.frame.size.width  / scale
        let newCenter = imageView.convert(center, from: scrollView)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }
    
    func centerIfNeeded() {
        var inset = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
        if scrollView.contentSize.height < scrollView.bounds.height - topInset {
            let insetV = (scrollView.bounds.height - topInset - scrollView.contentSize.height)/2
            inset.top += insetV
            inset.bottom = insetV
        }
        if scrollView.contentSize.width < scrollView.bounds.width {
            let insetV = (scrollView.bounds.width - scrollView.contentSize.width)/2
            inset.left = insetV
            inset.right = insetV
        }
        scrollView.contentInset = inset
    }

}


extension ProductPreviewCollectionViewCell: ReuseCollectionCellProtocol {
    static func configureCell<T>(collectionView: UICollectionView, indexPath: IndexPath, object: T?) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! ProductPreviewCollectionViewCell
        
        guard let urlString = object as? String else { return cell }
        cell.imageView.setImage(urlString: urlString, placeholder: .base) { (image) in
            cell.setNeedsLayout()
        }
        
        return cell
    }
}

extension ProductPreviewCollectionViewCell: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerIfNeeded()
    }

}
