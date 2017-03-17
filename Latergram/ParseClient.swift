//
//  ParseClient.swift
//  Latergram
//
//  Created by Satyam Jaiswal on 3/13/17.
//  Copyright © 2017 Satyam Jaiswal. All rights reserved.
//

import UIKit
import Parse

class ParseClient: NSObject {
    static var sharedInstance = ParseClient()
    
    func login(username: String, password: String, success: @escaping (PFUser) -> Void, failure: @escaping (Error) -> Void){
        print("login initiated...")
        PFUser.logInWithUsername(inBackground: username, password: password) { (user: PFUser?, error: Error?) in
            if let error = error {
                print("login failed")
                failure(error)
            }else{
                if let user = user {
                    print("login successful!")
                    success(user)
                }
            }
        }
    }
    
    func signup(username: String, password: String, success: @escaping (PFUser) -> Void, failure: @escaping (Error) -> Void){
    
        print("sign-up initiated...")
        let newUser = PFUser()
        newUser.username = username
        newUser.password = password
        
        newUser.signUpInBackground { (signupSuccessful: Bool, error: Error?) in
            if let error = error{
                print("sign-up failed!")
                failure(error)
            }else{
                print("sign-up successful!")
                if signupSuccessful {
                    success(newUser)
                }
            }
        }
    }
}
