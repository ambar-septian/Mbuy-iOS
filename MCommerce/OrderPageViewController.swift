//
//  OrderPageViewController.swift
//  MCommerce
//
//  Created by Ambar Septian on 6/22/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit

class OrderPageViewController: UIPageViewController {
    
    lazy var listViewControllers: [UIViewController] = {
        return [
           
            self.storyboard?.instantiateViewController(withIdentifier: Constants.viewController.order.child),
            self.storyboard?.instantiateViewController(withIdentifier: Constants.viewController.order.child)
        ]
    }() as! [UIViewController]

    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.dataSource = self
        
        if let initialVC = listViewControllers.first {
            setViewControllers([initialVC], direction: .forward, animated: false, completion: nil)
        }
    
        if let scrollView = view.subviews.filter({ $0.isKind(of: UIScrollView.self)}).first as? UIScrollView {
            scrollView.isScrollEnabled = false
        }
        
        guard let parent = parent as? OrderListViewController else { return }
        parent.delegate = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


//Mark: Extension class
extension OrderPageViewController: UIPageViewControllerDataSource{
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

extension OrderPageViewController: OrderParentProtocol {
    func didChildPageChange(index: Int) {
        if index == 1 {
            setViewControllers([listViewControllers[index]], direction: .forward, animated: true, completion: nil)
        }else{
            setViewControllers([listViewControllers[index]], direction: .reverse, animated: true, completion: nil)
        }

    }
}

