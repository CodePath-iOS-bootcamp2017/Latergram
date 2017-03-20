//
//  User.swift
//  Latergram
//
//  Created by Satyam Jaiswal on 3/13/17.
//  Copyright © 2017 Satyam Jaiswal. All rights reserved.
//

import UIKit
import Parse

class User: NSObject {
    var id: String?
    var name: String?
    var username: String?
    var profileImage: PFFile?
    var bio: String?
    var email: String?
    var website: URL?
    var gender: String?
    var phone: String?
    
    init(userPFObject: PFUser) {
        self.id = userPFObject.objectId
        
        if let name = userPFObject["name"] as? String{
            self.name = name
        }
        
        if let username = userPFObject.username{
            self.username = username
        }
        
        if let profileImage = userPFObject["profile_image"] as? PFFile{
            self.profileImage = profileImage
        }
        
        if let bio = userPFObject["bio"] as? String{
            self.bio = bio
        }
        
        if let email = userPFObject.email{
            self.email = email
        }
        
        if let website = userPFObject["website"] as? String{
            if let url = URL(string: website){
                self.website = url
            }
        }
        
        if let gender = userPFObject["gender"] as? String{
            self.gender = gender
        }
        
        if let phone = userPFObject["phone"] as? String{
            self.phone = phone
        }
    }
    
    init(name: String?, username: String?, bio: String?, website: URL?, email: String?, phone: String?, gender: String?, profileImage: PFFile?){
        if let name = name{
            self.name = name
        }
        
        if let username = username{
            self.username = username
        }
        
        if let profileImage = profileImage{
            self.profileImage = profileImage
        }
        
        if let bio = bio{
            self.bio = bio
        }
        
        if let email = email{
            self.email = email
        }
        
        if let website = website{
            self.website = website
        }
        
        if let gender = gender{
            self.gender = gender
        }
        
        if let phone = phone{
            self.phone = phone
        }
    }
    
    class func fetchUser(userId: String, success: @escaping (User) -> Void, failure: @escaping (Error) -> Void){
        ParseClient.sharedInstance.getUser(userId: userId, success: { (response: PFUser) in
            success(User(userPFObject: response))
        }) { (error: Error) in
            failure(error)
        }
    }
    
    class func updateMyProfile(name: String?, username: String?, bio: String?, website: URL?, email: String?, phone: String?, gender: String?, profileImage: PFFile?, success: @escaping (PFUser) -> Void, failure: @escaping (Error) -> Void){
        let user = User(name: name, username: username, bio: bio, website: website, email: email, phone: phone, gender: gender, profileImage: profileImage)
        ParseClient.sharedInstance.updateProfile(user: user, success: { (response: PFUser) in
            success(response)
        }) { (error: Error) in
            failure(error)
        }
    }
}
