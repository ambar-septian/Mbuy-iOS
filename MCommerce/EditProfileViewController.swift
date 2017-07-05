//
//  EditProfileViewController.swift
//  MCommerce
//
//  Created by Ambar Septian on 7/5/17.
//  Copyright © 2017 Ambar Septian. All rights reserved.
//

import UIKit
import Iconic

class EditProfileViewController: BaseViewController {

    @IBOutlet weak var profileImageView: UIImageView! {
        didSet {
            profileImageView.setImage(urlString: user.photoURL ?? "")
            profileImageView.addGestureRecognizer(profileGesture)
            profileImageView.isUserInteractionEnabled = true
        }
    }
    
    @IBOutlet weak var saveBarButton: UIBarButtonItem! {
        didSet {
            saveBarButton.title = "save".localize
        }
    }
    
    @IBOutlet weak var nameLabel: IconLabel! {
        didSet {
            nameLabel.text = "name".localize
            nameLabel.icon = .userIcon
        }
    }
    
    @IBOutlet weak var nameTextField: BorderTextField! {
        didSet {
            nameTextField.text = user.name
        }
    }
    
    lazy var profileGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(showImagePicker))
        return gesture
    }()
    
    lazy var imagePicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        return imagePicker
    }()
    
    lazy var actionSheet: UIAlertController = {
        let actionSheet = UIAlertController(title: nil, message: "changePhotoProfile".localize, preferredStyle: .actionSheet)
        
        let cameraButton = UIAlertAction(title: "takePhoto".localize, style: .default) { (alert) in
            let source:UIImagePickerControllerSourceType = UIImagePickerController.isSourceTypeAvailable(.camera) ? .camera : .photoLibrary
            self.imagePicker.sourceType = source
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        
        let selectButton = UIAlertAction(title: "selectPhoto".localize, style: .default) { (alert) in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        
        actionSheet.addAction(cameraButton)
        actionSheet.addAction(selectButton)
        
        return actionSheet
    }()
    
    fileprivate let user = User.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "editProfile".localize
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2
        profileImageView.layer.masksToBounds = true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func saveButtonTapped(_ sender: Any) {
    }
}

extension EditProfileViewController {
    func showImagePicker(){
        present(actionSheet, animated: true, completion: nil)
    }
}

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            profileImageView.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension EditProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         return handleTextFieldShouldReturn(textField)
    }
}
