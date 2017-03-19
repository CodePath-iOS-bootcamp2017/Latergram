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
    var name: String?
    var username: String?
    var profileImage: PFFile?
    var bio: String?
    var email: String?
    var website: URL?
    var gender: String?
    
    init(userPFObject: PFUser) {
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
    }
}
