//
//  AddEditUserTableViewController.swift
//  Athlos
//
//  Created by Lewis Luck on 15/9/18.
//  Copyright © 2018 Fortune Inc. All rights reserved.
//

import UIKit

class AddEditUserTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var profilePictureImage: UIImageView!
    @IBOutlet weak var firstNameLabel: UITextField!
    @IBOutlet weak var lastNameLabel: UITextField!
    @IBOutlet weak var nicknameLabel: UITextField!
    @IBOutlet weak var themeColourLabel: UILabel!
    @IBOutlet weak var themeColourCell: UITableViewCell!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var firstName: String? {
        return firstNameLabel.text
    }
    var lastName: String? {
        return lastNameLabel.text
    }
    var nickname: String? {
        if nicknameLabel.text == nil || nicknameLabel.text == "" {
            return nil
        } else {
        return nicknameLabel.text
        }
    }
    var profilePicture: UIImage? {
        return profilePictureImage.image
    }
    var themeColour: String? {
        if themeColourLabel.text == nil || themeColourLabel.text == "" || themeColourLabel.text == "Select" {
            return nil
        } else {
        return themeColourLabel.text
        }
    }
    
    var user: User?
    
    var editingUser: Bool = false
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "saveUser" {
            if self.user != nil {
                self.user = User(firstName: firstName!, lastName: lastName!, nickname: nickname, profilePicture: profilePicture, themeColour: themeColour)
            } else {
            self.user = User(firstName: firstName!, lastName: lastName!, nickname: nickname, profilePicture: profilePicture, themeColour: themeColour)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        if let user = self.user {
            firstNameLabel.text = user.firstName
            lastNameLabel.text = user.lastName
            profilePictureImage.image = user.convertToImage()
            nicknameLabel.text = user.nickname
            if let userThemeColour = user.themeColour {
                themeColourCell.backgroundColor = User.convertToColour(colour: userThemeColour)
                themeColourLabel.text = userThemeColour
            }
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func setCircleImage() {
        profilePictureImage.layer.cornerRadius = profilePictureImage.frame.height/2
        profilePictureImage.layer.masksToBounds = false
        profilePictureImage.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 3 && indexPath.row == 0 {
            performSegue(withIdentifier: "ChooseColour", sender: nil)
        }
        
        if indexPath.row == 0 && indexPath.section == 0 {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            
            let alertController = UIAlertController(title: "Choose Image Source", message: nil, preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default, handler: { (action) in
                    imagePicker.sourceType = .photoLibrary
                    self.present(imagePicker, animated: true, completion: nil)
                })
                alertController.addAction(photoLibraryAction)
            }
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: { (action) in
                    imagePicker.sourceType = .camera
                    self.present(imagePicker, animated: true, completion: nil)
                })
                alertController.addAction(cameraAction)
            }
            
            alertController.addAction(cancelAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profilePictureImage.image = selectedImage
            dismiss(animated: true, completion: nil)
            updateUI()
        }
    }
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    func updateColourCell() {
         if let themeColour = themeColour {
            themeColourCell.backgroundColor = User.convertToColour(colour: themeColour)
            themeColourLabel.text = themeColour
        } else {
            themeColourCell.backgroundColor = UIColor.black
            themeColourLabel.text = "Select"
        }
    }
    
    func updateSaveButton() {
        let firstNameCheck = firstNameLabel.text ?? ""
        let lastNameCheck = lastNameLabel.text ?? ""
        saveButton.isEnabled = !firstNameCheck.isEmpty && !lastNameCheck.isEmpty
    }
    
    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateSaveButton()
    }
    
    func updateUI() {
        updateColourCell()
        updateSaveButton()
        if profilePicture != nil {
        profilePictureImage.image = profilePicture
        }
        setCircleImage()
    }
    
    @IBAction func unwindFromColourChoice(unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source as? ChooseColourTableViewController
        if let colourChosen = sourceViewController?.colourChoice {
            self.themeColourLabel.text = colourChosen
        }
        updateUI()
    }
    
    
    

}
