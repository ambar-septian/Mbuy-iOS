//
//  CheckOutPageViewController.swift
//  MCommerce
//
//  Created by Ambar Septian on 6/25/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit

class CheckOutPageViewController: UIPageViewController {
    lazy var listViewControllers: [UIViewController] = {
        return [
            
            self.storyboard?.instantiateViewController(withIdentifier: Constants.viewController.checkout.profile),
            self.storyboard?.instantiateViewController(withIdentifier: Constants.viewController.checkout.address),
            self.storyboard?.instantiateViewController(withIdentifier: Constants.viewController.checkout.summary)
        ]
        }() as! [UIViewController]
    
    fileprivate var currentIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        
        if let initialVC = listViewControllers.first {
            setViewControllers([initialVC], direction: .forward, animated: false, completion: nil)
        }
        
        if let scrollView = view.subviews.filter({ $0.isKind(of: UIScrollView.self)}).first as? UIScrollView {
            scrollView.isScrollEnabled = false
        }
        
        guard let parent = parent as? CheckOutMainViewController else { return }
        parent.delegate = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


//Mark: Extension class
extension CheckOutPageViewController: UIPageViewControllerDataSource{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = listViewControllers.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        return listViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = listViewControllers.index(of: viewController) else{
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        guard listViewControllers.count > nextIndex else {
            return nil
        }
        
        return listViewControllers[nextIndex]
    }
}

extension CheckOutPageViewController: CheckOutParentProtocol {
    func didChildPageChange(index: Int) {
        guard listViewControllers.count - 1 >= index else { return }
        if index > currentIndex {
            setViewControllers([listViewControllers[index]], direction: .forward, animated: true, completion: nil)
        }else{
            setViewControllers([listViewControllers[index]], direction: .reverse, animated: true, completion: nil)
        }
        
        currentIndex = index

    }
}
