//
//  EditProfileViewController.swift
//  Latergram
//
//  Created by Satyam Jaiswal on 3/18/17.
//  Copyright © 2017 Satyam Jaiswal. All rights reserved.
//

import UIKit
import ParseUI
import SVProgressHUD

class EditProfileViewController: UIViewController, UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    
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
    
    fileprivate var selectedGender: String?
    
    let genderData = ["Not Specified", "Male", "Female"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupGenderPickerView()
        self.updateUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.updateScrollViewContentSize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    fileprivate func setupGenderPickerView(){
        self.genderPickerView.delegate = self
        self.genderPickerView.dataSource = self
        self.genderPickerView.reloadAllComponents()
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    /*
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.genderData[row]
    }
    */
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let genderDataLabel = UILabel()
        genderDataLabel.text = self.genderData[row]
        genderDataLabel.font = UIFont(name: "System", size: 10.0)
        return genderDataLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch row{
        case 0:
            self.selectedGender = "Not Specified"
        case 1:
            self.selectedGender = "Male"
        case 2:
            self.selectedGender = "Female"
        default:
            self.selectedGender = "Not Specified"
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    fileprivate func updateUI(){
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
                self.profileImageView.loadInBackground()
            }
            
            if let gender = meUserObj.gender{
                switch gender {
                case "Not Specified":
                    self.genderPickerView.selectRow(0, inComponent: 0, animated: true)
                case "Male":
                    self.genderPickerView.selectRow(1, inComponent: 0, animated: true)
                case "Female":
                    self.genderPickerView.selectRow(2, inComponent: 0, animated: true)
                default:
                    self.genderPickerView.selectRow(0, inComponent: 0, animated: true)
                }
            }
            
            self.profileImageView.layer.cornerRadius = 50.0
            self.profileImageView.layer.masksToBounds = true
        }
    }
    
    fileprivate func configureScrollView(){
        self.editProfileScrollView.delegate = self
        self.updateScrollViewContentSize()
    }
    
    fileprivate func updateScrollViewContentSize(){
        let width = self.editProfileScrollView.bounds.width
        let height = self.privateInformationStackView.frame.maxY + 400.0
        self.editProfileScrollView.contentSize = CGSize(width: width, height: height)
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        self.updateScrollViewContentSize()
    }
    
    @IBAction func onCloseButtonTapped(_ sender: Any) {
        self.closeKeypad()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSaveButtonTapped(_ sender: Any) {
        self.closeKeypad()
        if self.validateFormFields(){
            SVProgressHUD.show()
            User.updateMyProfile(name: self.nameTextField.text, username: self.usernameTextField.text, bio: self.bioTextField.text, website: self.getUrlFromString(urlString: self.websiteTextField.text), email: self.emailTextField.text, phone: self.phoneTextField.text, gender: self.selectedGender, profileImage: Post.getPFFileFromImage(image: self.profileImageView.image), success: { (updatedUser: PFUser) in
                SVProgressHUD.dismiss()
                self.dismiss(animated: true, completion: nil)
            }) { (error: Error) in
                SVProgressHUD.dismiss()
                print("Error updating profile information: \(error.localizedDescription)")
                AlertView.sharedInstance.presentAlertController(viewController: self, title: "Error!", message: error.localizedDescription)
            }
        }else{
            AlertView.sharedInstance.presentAlertController(viewController: self, title: "Error!", message: "Invalid Website URL")
        }
    }

    @IBAction func onChangePhotoButtonTapped(_ sender: Any) {
        self.instantiateUIImagePickerController()
    }
    
    fileprivate func instantiateUIImagePickerController(){
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        self.present(vc, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        print("didFinishPickingMediaWithInfo called")
        // Get the image captured by the UIImagePickerController
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.profileImageView.image = self.resize(image: originalImage, newSize: CGSize(width: 100.0, height: 100.0))
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate func resize(image: UIImage, newSize: CGSize) -> UIImage {
        let resizeImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        resizeImageView.contentMode = UIViewContentMode.scaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    fileprivate func validateFormFields() -> Bool{
        if let websiteString = self.websiteTextField.text{
            if !websiteString.isEmpty{
                if self.getUrlFromString(urlString: websiteString) == nil{
                    return false
                }
            }
        }
        return true
    }
    
    fileprivate func getUrlFromString(urlString: String?) -> URL?{
        if let url = urlString{
            return URL(string: url)
        }
        
        return nil
    }
    
    fileprivate func closeKeypad(){
        self.nameTextField.resignFirstResponder()
        self.usernameTextField.resignFirstResponder()
        self.bioTextField.resignFirstResponder()
        self.websiteTextField.resignFirstResponder()
        self.emailTextField.resignFirstResponder()
        self.phoneTextField.resignFirstResponder()
    }
    
    @IBAction func onBackgroundTapped(_ sender: Any) {
        self.closeKeypad()
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
