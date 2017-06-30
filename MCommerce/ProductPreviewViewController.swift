//
//  ProductPreviewViewController.swift
//  MCommerce
//
//  Created by Ambar Septian on 6/18/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit
import Iconic

class ProductPreviewViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.image = nil
            imageView.contentMode = .scaleAspectFit
            //imageView.heroID = Constants.heroID.productPreview
        }
    }
    
    
    @IBOutlet weak var closeButton: BasicButton! {
        didSet {
            let iconString = FontAwesomeIcon.removeIcon.attributedString(ofSize: 25 , color: Color.orange)
            closeButton.setAttributedTitle(iconString, for: .normal)
        }
    }
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!
    
    fileprivate var presentingNavigationController: UINavigationController? {
        return presentingViewController?.navigationController
    }
    
    var passedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = passedImage
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    
 
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateMinZoomScaleForSize(size: view.bounds.size)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presentingNavigationController?.setNavigationBarHidden(true, animated: true)
        presentingNavigationController?.navigationBar.isUserInteractionEnabled = false

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ProductPreviewViewController {
    
    fileprivate func updateConstraintsForSize(size: CGSize) {
        let yOffset = max(0, (size.height - imageView.frame.height) / 2)
        topConstraint.constant = yOffset
        bottomConstraint.constant = yOffset
        let xOffset = max(0, (size.width - imageView.frame.width) / 2)
        leadingConstraint.constant = xOffset
        trailingConstraint.constant = xOffset
        
        view.layoutIfNeeded()
    }
    
    fileprivate func updateMinZoomScaleForSize(size: CGSize) {
        let widthScale = size.width / imageView.bounds.width
        let heightScale = size.height / imageView.bounds.height
        let minScale = min(widthScale, heightScale)
        
        UIView.animate(withDuration: 0.3) { 
            self.scrollView.minimumZoomScale = minScale
            self.scrollView.zoomScale = minScale
        }
        
    }
}

extension ProductPreviewViewController {
    @IBAction func closeButtonTapped(_ sender: Any) {
        presentingNavigationController?.setNavigationBarHidden(false, animated: true)
        presentingNavigationController?.navigationBar.isUserInteractionEnabled = true
        dismiss(animated: true, completion: nil)
    }

}

extension ProductPreviewViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateConstraintsForSize(size: view.bounds.size)
    }
    
}

