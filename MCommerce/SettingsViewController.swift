//
//  SettingsViewController.swift
//  MCommerce
//
//  Created by Ambar Septian on 7/1/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit
import Iconic

class SettingsViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var contents : [(title:String, icon:FontAwesomeIcon)] =
        [(title:"changeLanguage", icon:.globeIcon),
         (title:"logout", icon:.signoutIcon)]
    
    fileprivate let controller = AuthController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "settings".localize
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension SettingsViewController {
    func logout(){
        self.showProgressHUD()
        DispatchQueue.global().async {
            self.controller.logout(completion: { (completed) in
                DispatchQueue.main.async {
                    self.hideProgressHUD()
                    
                    guard completed else { return }
                    
                    self.controller.dismissViewControllerToLogin(currentVC: self)
                }
            })
        }
    }
    
    func confirmationLogout(){
        Alert.showAlert(message: "confirmationLogout".localize, alertType: .okCancel, header: nil, viewController: self) { (alert) in
            self.logout()
        }
    }
}

extension SettingsViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.accessoryType = indexPath.row == 0 ? .disclosureIndicator : .none
        guard let label = cell.contentView.viewWithTag(10) as? IconLabel else { return cell }
        
        let content = contents[indexPath.row]
        label.text = content.title.localize
        label.icon = content.icon
        label.textColor = indexPath.row == contents.count - 1 ? Color.red : Color.darkGray
        return cell
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 1 {
            confirmationLogout()
        }
    }
}
