//
//  LoginViewController.swift
//  Latergram
//
//  Created by Satyam Jaiswal on 3/12/17.
//  Copyright © 2017 Satyam Jaiswal. All rights reserved.
//

import UIKit
import Parse
import SVProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let alertController = UIAlertController(title: "Title", message: "message", preferredStyle: .alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupAlertController()
    }

    func setupAlertController(){
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction) in
            
        }
        self.alertController.addAction(OKAction)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLoginTapped(_ sender: Any) {
        if validateFields() {
            SVProgressHUD.show()
            let username = self.usernameTextField.text!
            let password = self.passwordTextField.text!
            
            ParseClient.sharedInstance.login(username: username, password: password, success: { (user: PFUser) in
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "loginSegue", sender: sender)
                
            }) { (error: Error) in
                SVProgressHUD.dismiss()
                print(error.localizedDescription)
                self.presentAlertController(title: "Error!", message: error.localizedDescription)
            }
        }
    }

    
    @IBAction func onSignupTapped(_ sender: Any) {
        if validateFields() {
            SVProgressHUD.show()
            let username = self.usernameTextField.text!
            let password = self.passwordTextField.text!
            ParseClient.sharedInstance.signup(username: username, password: password, success: { (user: PFUser) in
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "loginSegue", sender: sender)
            }) { (error: Error) in
                SVProgressHUD.dismiss()
                print(error.localizedDescription)
                self.presentAlertController(title: "Error!", message: error.localizedDescription)
            }
        }
    }
    
    func validateFields() -> Bool{
        if let username = self.usernameTextField.text{
            if username.isEmpty {
                self.presentAlertController(title: "Sorry!", message: "Username is required")
                return false
            }
        }else if let password = self.passwordTextField.text{
            if password.isEmpty{
                self.presentAlertController(title: "Sorry!", message: "Password is required")
                return false
            }
        }
        
        return true
    }
    
    func presentAlertController(title: String, message: String){
        self.alertController.title = title
        self.alertController.message = message
        self.present(self.alertController, animated: true, completion: nil)
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
