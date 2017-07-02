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
    
    fileprivate var headingView: UIView? {
        guard let parent = parent as? CheckOutMainViewController else { return nil }
        return parent.headerView
    }
    
    fileprivate var timelineView: HorizontalTimelineView? {
        guard let parent = parent as? CheckOutMainViewController else { return nil }
        return parent.timelineView
    }
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        
        if let initialVC = listViewControllers.first as? CheckOutProfileViewController {
            setViewControllers([initialVC], direction: .forward, animated: false, completion: nil)
            initialVC.childDelegate = self
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

extension CheckOutPageViewController {
    func toggleHideHeadingView(){
        guard let headingView = self.headingView else { return }
        let isHidden = headingView.isHidden
        let animation: UIViewAnimationOptions = isHidden  == true ? .curveEaseOut : .curveEaseOut
    
        UIView.animate(withDuration: 0.3, delay: 0, options: animation, animations: { 
            headingView.isHidden = !(isHidden)
        }) { (completed) in
            guard completed else { return }
            self.timelineView?.moveActiveCircleView(index: self.currentIndex, withAnimation: true)
        }
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
        
        switch index {
        case 0:
            guard let vc = listViewControllers[index] as? CheckOutProfileViewController else { return }
            vc.childDelegate = self
        case 1:
            guard let vc = listViewControllers[index] as? CheckOutAddressViewController else { return }
            vc.childDelegate = self

        default: break
        
        }
        currentIndex = index
    }
    
    func didFormIsValid() -> (isValid:Bool, message: String?) {
        switch currentIndex {
        case 0:
            guard let vc = listViewControllers[currentIndex] as? CheckOutProfileViewController else {  return (isValid:false, message: nil) }
            return vc.validateForm()
        case 1:
            guard let vc = listViewControllers[currentIndex] as? CheckOutAddressViewController else { return (isValid:false, message: nil) }
            return vc.validateForm()
        default:
            return (isValid:true, message: nil)
        }
    }
    
    func updateOrderProfile() {
        guard let parent = parent as? CheckOutMainViewController else { return }
        let profile = parent.profile
       
        switch currentIndex {
        case 0:
            guard let vc = listViewControllers[currentIndex] as? CheckOutProfileViewController else { return }
            profile.email = vc.emailTextField.text ?? ""
            profile.name = vc.nameTextField.text ?? ""
            profile.phone = vc.phoneTextField.text ?? ""
            
        case 1:
            guard let vc = listViewControllers[currentIndex] as? CheckOutAddressViewController else {  return }
            profile.address = vc.addressTextView.text
            profile.deliveryCost = vc.deliveryCost
            profile.note = vc.noteTextView.text
            guard let place = vc.selectedPlace else { return }
            profile.coordinate = place.coordinate
            
      
            
        default:
            break
        }
    }
}

extension CheckOutPageViewController: CheckOutChildProtocol {
    func didBeginTypingComponent() {
        toggleHideHeadingView()
    }
    
    func didEndTypingComponent() {
        toggleHideHeadingView()
    }
}
