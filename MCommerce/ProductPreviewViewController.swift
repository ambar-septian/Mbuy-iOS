//
//  ProductPreviewViewController.swift
//  MCommerce
//
//  Created by Ambar Septian on 6/18/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit
import Iconic

class ProductPreviewViewController: BaseViewController {

    @IBOutlet weak var closeButton: BasicButton! {
        didSet {
            let iconString = FontAwesomeIcon.removeIcon.attributedString(ofSize: 25 , color: Color.orange)
            closeButton.setAttributedTitle(iconString, for: .normal)
        }
    }
  
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            let cell = ProductPreviewCollectionViewCell.self
            collectionView.register(cell.nib, forCellWithReuseIdentifier: cell.identifier)
        }
    }
    
    @IBOutlet weak var pageControl: UIPageControl! {
        didSet {
            pageControl.numberOfPages = passedImageURLs.count
        }
    }
    
    fileprivate var presentingNavigationController: UINavigationController? {
        return presentingViewController?.navigationController
    }
    
    var passedImageURLs =  [String]()
    
    var passedSelectedIndex: Int?
  
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    
        collectionView.reloadData()
        title = ""
        setNavigationControllerBackground(color: UIColor.clear)
        
        addDismissBarButton()
    }
    
 
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    
        guard let index = passedSelectedIndex else { return }
        let indexPath = IndexPath(item: index, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .right, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        presentingNavigationController?.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
//        presentingNavigationController?.setNavigationBarHidden(true, animated: true)
//        presentingNavigationController?.navigationBar.isUserInteractionEnabled = false
       
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        presentingNavigationController?.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
//        presentingNavigationController?.setNavigationBarHidden(false, animated: true)
//        presentingNavigationController?.navigationBar.isUserInteractionEnabled = true
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}



extension ProductPreviewViewController {


}


extension ProductPreviewViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return passedImageURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imageURL = passedImageURLs[indexPath.item]
        let cell = ProductPreviewCollectionViewCell.configureCell(collectionView: collectionView, indexPath: indexPath, object: imageURL) as! ProductPreviewCollectionViewCell
//        cell.updateConstraintsForSize(size: view.bounds.size)
        return cell
    }
    
    
    
}

extension ProductPreviewViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return view.bounds.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.1
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ProductPreviewCollectionViewCell else { return }
        
    }
}


extension ProductPreviewViewController {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView == collectionView else { return }
        let index = Int(round(collectionView.contentOffset.x / collectionView.frame.width))
        pageControl.currentPage = index
    }
}



