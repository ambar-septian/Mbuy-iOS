//
//  SettingsViewController.swift
//  MCommerce
//
//  Created by Ambar Septian on 7/1/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit
import Iconic

protocol UpdateProfileDelegate:class {
    func didUpdateProfile(image: UIImage)
}

class SettingsViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var contents : [(title:String, icon:FontAwesomeIcon)] =
        [
        (title:"changePassword", icon:.lockIcon),
        (title:"changeLanguage", icon:.globeIcon),
         (title:"logout", icon:.signoutIcon)]
    
    fileprivate let sections: [(title:String, count:Int)] = [
        (title:"userProfile", count: 2),
        (title:"settings", count: 2)
    ]
    
 
    fileprivate let controller = AuthController()
   
    fileprivate let user = User.shared
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == Constants.segueID.setting.editProfile else { return }
        guard let vc = segue.destination as? EditProfileViewController else { return }
        vc.delegate = self
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        if indexPath.section == 0 && indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
            let contentView = cell.contentView
            cell.layoutIfNeeded()
            
            if let imageView = contentView.viewWithTag(10) as? UIImageView {
                imageView.layer.masksToBounds = true
                let size = min(imageView.bounds.width, imageView.bounds.height)
                imageView.frame.size = CGSize(width: size, height: size)
                imageView.layer.cornerRadius = size / 2
                
                if let photoURL = user.photoURL, imageView.image == nil {
                    imageView.setImage(urlString: photoURL, placeholder: .user)
                }
                
            }
            
            if let nameLabel = contentView.viewWithTag(11) as? UILabel {
                nameLabel.text = user.name
            }
            
            if let emailLabel = contentView.viewWithTag(12) as? UILabel {
                emailLabel.text = user.email
            }
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath)
            guard let label = cell.contentView.viewWithTag(10) as? IconLabel else { return cell }
            
            let row = indexPath.section == 0 ? 0 : indexPath.row
            let contentIndex = indexPath.section + row
            let content = contents[contentIndex]
            label.text = content.title.localize
            label.icon = content.icon
            label.textColor = row == contents.count - 1 ? Color.red : Color.darkGray
            cell.accessoryType = row == contents.count - 1 ? .disclosureIndicator : .none
            
            
            if indexPath.section == 0 && indexPath.row == 1 && user.userType == .facebook {
                cell.isUserInteractionEnabled = false
                label.textColor = Color.lightGray
            }
            
            
            return cell

        }
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let row = indexPath.section == 1 ? indexPath.row + 1 : indexPath.row
        let contentIndex = indexPath.section + row
        
        switch contentIndex {
        case 0: // user profile
            performSegue(withIdentifier: Constants.segueID.setting.editProfile, sender: nil)
        case 1: // change password
            performSegue(withIdentifier: Constants.segueID.setting.changePassword, sender: nil)
        case 2:
            performSegue(withIdentifier: Constants.segueID.setting.changeLanguage, sender: nil)
        case 3: // logout
            self.confirmationLogout()
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 0 {
            return 100
        } else {
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view =  UILabel(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: tableView.bounds.width, height: 30)))
        view.backgroundColor = Color.clear

        let label = UILabel(frame: view.bounds)
        label.frame.origin.x += 10
        label.font = Font.latoBold.withSize(14)
        label.textColor = Color.lightGray
        label.text = sections[section].title.localize
        
        view.addSubview(label)
        
        return view
    }
    
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 0.1
//    }
//    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
}

extension SettingsViewController: UpdateProfileDelegate {
    func didUpdateProfile(image: UIImage) {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = tableView(tableView, cellForRowAt: indexPath)
        guard let imageView = cell.contentView.viewWithTag(10) as? UIImageView else { return }
        imageView.image = image
    }
}
