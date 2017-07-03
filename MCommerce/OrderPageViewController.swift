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
        let onProcessVC =
            self.storyboard?.instantiateViewController(withIdentifier: Constants.viewController.order.child) as! OrderListChildViewController
        onProcessVC.currentPage = 0
        
        let completedVC =
            self.storyboard?.instantiateViewController(withIdentifier: Constants.viewController.order.child) as! OrderListChildViewController
        completedVC.currentPage = 1
        
        return [onProcessVC, completedVC]
        
    }()
    
    fileprivate var parentVC:OrderListViewController? {
        return parent as? OrderListViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.dataSource = self
        self.delegate = self
        
        if let initialVC = listViewControllers.first {
            setViewControllers([initialVC], direction: .forward, animated: false, completion: nil)
        }

      
        parentVC?.delegate = self

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
        
        parentVC?.activePageIndex = previousIndex
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
        
        parentVC?.activePageIndex = nextIndex
        return listViewControllers[nextIndex]
    }
}

extension OrderPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard finished else { return }
        guard let index = parentVC?.activePageIndex else { return }
        parentVC?.didChangeChildPage(row: index, withChangePage: false)
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
    
    func didOrderFinishLoad(index: Int) {
        guard let vc = listViewControllers[index] as? OrderListChildViewController else { return }
        vc.tableView.reloadData()
        vc.tableViewConstraint.constant = vc.tableView.contentSize.height
    }
}

