//
//  EditProfileViewController.swift
//  Latergram
//
//  Created by Satyam Jaiswal on 3/18/17.
//  Copyright © 2017 Satyam Jaiswal. All rights reserved.
//

import UIKit
import ParseUI

class EditProfileViewController: UIViewController, UIScrollViewDelegate {

    
    @IBOutlet weak var editProfileScrollView: UIScrollView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var bioTextField: UITextField!
    @IBOutlet weak var profileImageView: PFImageView!
    @IBOutlet weak var privateInformationStackView: UIStackView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var genderPickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.updateScrollViewContentSize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func updateUI(){
        if let me = PFUser.current() {
            let meUserObj = User(userPFObject: me)
            
            if let name = meUserObj.name{
                self.nameTextField.text = name
            }
            
            if let username = meUserObj.username{
                self.usernameTextField.text = username
            }
            
            if let website = meUserObj.website{
                self.websiteTextField.text = website.absoluteString
            }
            
            if let bio = meUserObj.bio {
                self.bioTextField.text = bio
            }
            
            if let email = meUserObj.email{
                self.emailTextField.text = email
            }
            
            if let phone = meUserObj.phone{
                self.phoneTextField.text = phone
            }
            
            if let profileImage = meUserObj.profileImage{
                self.profileImageView.file = profileImage
                self.profileImageView.layer.cornerRadius = 50.0
                self.profileImageView.layer.masksToBounds = true
                self.profileImageView.loadInBackground()
            }
        }
    }
    
    func configureScrollView(){
        self.editProfileScrollView.delegate = self
        self.updateScrollViewContentSize()
    }
    
    func updateScrollViewContentSize(){
        let width = self.editProfileScrollView.bounds.width
        let height = self.privateInformationStackView.frame.maxY + 100.0
        self.editProfileScrollView.contentSize = CGSize(width: width, height: height)
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        self.updateScrollViewContentSize()
    }
    
    @IBAction func onCloseButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSaveButtonTapped(_ sender: Any) {
        if self.validateFormFields(){
            User.updateMyProfile(name: self.nameTextField.text, username: self.usernameTextField.text, bio: self.bioTextField.text, website: self.getUrlFromString(urlString: self.websiteTextField.text), email: self.emailTextField.text, phone: self.phoneTextField.text, gender: nil, profileImage: self.profileImageView.file, success: { (updatedUser: PFUser) in
                //            PFUser.current() = updatedUser
                self.dismiss(animated: true, completion: nil)
            }) { (error: Error) in
                print("Error updating profile information: \(error.localizedDescription)")
            }
        }else{
            AlertView.sharedInstance.presentAlertController(viewController: self, title: "Error!", message: "Invalid Website URL")
        }
        
    }

    @IBAction func onChangePhotoButtonTapped(_ sender: Any) {
        
    }
    
    func validateFormFields() -> Bool{
        if let websiteString = self.websiteTextField.text{
            if !websiteString.isEmpty{
                if self.getUrlFromString(urlString: websiteString) == nil{
                    return false
                }
            }
        }
        return true
    }
    
    func getUrlFromString(urlString: String?) -> URL?{
        if let url = urlString{
            return URL(string: url)
        }
        
        return nil
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
