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
    fileprivate let postClassName = "Post"
    
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
    
    func newPost(media: PFFile?, caption: String?, success: @escaping (PFObject)-> Void, failure: @escaping (Error) -> Void){
        let post = PFObject(className: postClassName)
        
        if let postImage = media {
            post["media"] = postImage
        }
        
        if let postCaption = caption{
            post["caption"] = postCaption
        }
        
        post["author"] = PFUser.current()
        post["likes_count"] = 0
        post["comments_count"] = 0
        post.saveInBackground { (result: Bool, error: Error?) in
            if let error = error{
                failure(error)
            }else{
                if result {
                    success(post)
                }
            }
        }
    }
    
    func getPosts(success: @escaping ([PFObject]) -> Void, failure: @escaping (Error) -> Void){
        let query = PFQuery(className: postClassName)
        query.order(byDescending: "createdAt")
        query.includeKey("author")
        query.includeKey("caption")
        query.includeKey("likes_count")
        query.includeKey("comments_count")
        query.limit = 20
        query.findObjectsInBackground { (response: [PFObject]?, error: Error?) in
            if let error = error{
                failure(error)
            }else{
                if let posts = response{
                    success(posts)
                }
            }
        }
    }
    
    func getUserPosts(user: PFUser, success: @escaping ([PFObject]) -> Void, failure: @escaping (Error) -> Void) {
        let query = PFQuery(className: postClassName)
        query.whereKey("author", equalTo: user)
        query.order(byDescending: "createdAt")
        query.includeKey("author")
        query.includeKey("caption")
        query.includeKey("likes_count")
        query.includeKey("comments_count")
        query.limit = 20
        query.findObjectsInBackground { (response: [PFObject]?, error: Error?) in
            if let error = error{
                failure(error)
            }else{
                if let response = response{
                    success(response)
                }
            }
        }
    }
    
    func getUser(userId: String, success: @escaping (PFUser) -> Void, failure: @escaping (Error) -> Void){
        if let query = PFUser.query(){
            query.includeKey("bio")
            query.includeKey("profile_image")
            query.includeKey("name")
            query.getObjectInBackground(withId: userId, block: { (response: PFObject?, error: Error?) in
                if let error = error {
                    failure(error)
                }else{
                    if let response = response as? PFUser{
                        success(response)
                    }else{
                        print("can't cast PFObject to PFUser")
                    }
                }
            })
        }
    }
}
