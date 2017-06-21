//
//  BaseViewController.swift
//  MCommerce
//
//  Created by Ambar Septian on 5/16/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit
import Iconic
import Hero

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        addKeyboardGesture()
        setupNotificationHideKeyboard()
        view.backgroundColor = Color.cream
        navigationController?.isHeroEnabled = true
        isHeroEnabled = true
        
        guard let nav = navigationController else { return }
        guard let rootVC = nav.viewControllers.first else { return }
        guard rootVC != self else { return }
        addBackButton()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit {
        removeNotificationHideKeyboard()
    }
}

extension BaseViewController {
    
    
    func addKeyboardGesture(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func addDismissBarButton(rightPosition: Bool = true){
        let image = #imageLiteral(resourceName: "btnClose").withRenderingMode(.alwaysOriginal)
        let barButton =  UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(self.dismissVC))
        
        if rightPosition {
            navigationItem.rightBarButtonItem = barButton
        } else {
            navigationItem.leftBarButtonItem = barButton
        }
        
    }
    
    func addBackButton(){
        let size = CGSize(width: 1, height: 1)
        let image = FontAwesomeIcon.angleLeftIcon.image(ofSize: size, color: Color.white).withRenderingMode(.alwaysOriginal)
        let barButton =  UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(self.popBack))

        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationItem.leftBarButtonItem = barButton
    }
    
    internal func dismissKeyboard(){
        view.endEditing(true)
    }
    
    
  
    
    internal func setupNotificationHideKeyboard(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    internal func removeNotificationHideKeyboard(){
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    internal func keyboardWillShow(notification: NSNotification) {
        guard let scrollView = view.viewWithTag(Constants.viewTag.scrollView) as? UIScrollView else { return }
        guard let userInfo = notification.userInfo else { return }
        guard var keyboardFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else { return }
        keyboardFrame = view.convert(keyboardFrame, from: nil)
        
        var contentInset = scrollView.contentInset
        let margin:CGFloat = view.frame.height * 0.1
        contentInset.bottom = keyboardFrame.size.height + margin
        
        UIView.animate(withDuration: 0.5) {
            scrollView.contentInset = contentInset
        }
        
    }
    
    internal func keyboardWillHide(notification: NSNotification){
        guard let scrollView = view.viewWithTag(Constants.viewTag.scrollView) as? UIScrollView else { return }
        let contentInset = UIEdgeInsets.zero
        
        UIView.animate(withDuration: 0.5) {
            scrollView.contentInset = contentInset
        }
    }
    
}

extension BaseViewController {
    func setNavigationControllerBackground(color: UIColor, isTranslucent: Bool = false){
        let navigationBar = navigationController?.navigationBar
        let backgroundImage = UIImage(color: color)
        navigationBar?.setBackgroundImage(backgroundImage, for: .default)
        navigationBar?.shadowImage = UIImage()
        navigationBar?.isTranslucent = isTranslucent
        navigationBar?.backgroundColor = .clear
        navigationController?.view.backgroundColor = .clear
    }
    
    func pushNavigation(targetVC: UIViewController){
//        Hero.shared.setDefaultAnimationForNextTransition(.slide(direction: .right))
//        Hero.shared.setContainerColorForNextTransition(.lightGray)
//        hero_replaceViewController(with: targetVC)
        navigationController?.pushViewController(targetVC, animated: true)
        
    }
    
    func dismissVC(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func popBack(){
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    static func adjustNavigationBar(){
        let navigationBarAppearance = UINavigationBar.appearance()
       
        navigationBarAppearance.barTintColor = Color.orange
        navigationBarAppearance.isTranslucent = false
        navigationBarAppearance.titleTextAttributes = [NSForegroundColorAttributeName: Color.white, NSFontAttributeName: Font.latoBold]

        UIApplication.shared.statusBarStyle = .lightContent
    }

    

}

extension BaseViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}


extension BaseViewController {
    
    func handleTextFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == .next {
            let currentTag = textField.tag
            guard let nextTextField = view.viewWithTag(currentTag + 1) else {
                return true }
            nextTextField.becomeFirstResponder()
        } else if textField.returnKeyType == .done {
            textField.resignFirstResponder()
            
        }
        
        return true
    }
    
}
