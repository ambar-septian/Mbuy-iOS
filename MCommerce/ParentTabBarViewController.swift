//
//  TabBarViewController.swift
//  MCommerce
//
//  Created by Ambar Septian on 5/22/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit
import Iconic

class ParantTabBarViewController: UITabBarController {
    
    lazy var homeVC: UINavigationController = {
        let vc = HomeViewController()
        let nav = UINavigationController(rootViewController: vc)
        let size = CGSize(width: 25, height: 25)
        vc.tabBarItem = UITabBarItem(withIcon: FontAwesomeIcon.homeIcon, size: size, title: "home".localize)
        
        return nav
    }()
    
    lazy var searchVC: UINavigationController = {
        let vc = HomeViewController()
        let nav = UINavigationController(rootViewController: vc)
        let size = CGSize(width: 25, height: 25)
        vc.tabBarItem = UITabBarItem(withIcon: FontAwesomeIcon.searchIcon, size: size, title: "search".localize)
        
        return nav
    }()
    
    lazy var cartVC: UINavigationController = {
        let vc = HomeViewController()
        let nav = UINavigationController(rootViewController: vc)
        let size = CGSize(width: 25, height: 25)
        vc.tabBarItem = UITabBarItem(withIcon: FontAwesomeIcon.shoppingCartIcon, size: size, title: "cart".localize)
        
        return nav
    }()
    
    lazy var ordersVC: UINavigationController = {
        let vc = HomeViewController()
        let nav = UINavigationController(rootViewController: vc)
        let size = CGSize(width: 25, height: 25)
        vc.tabBarItem = UITabBarItem(withIcon: FontAwesomeIcon.truckIcon, size: size, title: "orders".localize)
        
        return nav
    }()
    
    lazy var settingsVC: UINavigationController = {
        let vc = HomeViewController()
        let nav = UINavigationController(rootViewController: vc)
        let size = CGSize(width: 25, height: 25)
        vc.tabBarItem = UITabBarItem(withIcon: FontAwesomeIcon.cogsIcon, size: size, title: "settings".localize)
        
        return nav
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewControllers = [homeVC, searchVC, cartVC, ordersVC, settingsVC]
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
