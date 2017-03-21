//
//  Post.swift
//  Latergram
//
//  Created by Satyam Jaiswal on 3/18/17.
//  Copyright © 2017 Satyam Jaiswal. All rights reserved.
//

import UIKit
import Parse

class Post: NSObject {
    var id: String?
    var media: PFFile?
    var author: User?
    var caption: String?
    var likesCount: Int?
    var commentsCount: Int?
    var timestamp: Date?
    var location: String?
    
    init(postPFPbject: PFObject) {
        
        self.id = postPFPbject.objectId
        
        if let media = postPFPbject["media"] as? PFFile{
            self.media = media
        }
        
        if let authorPFUser = postPFPbject["author"] as? PFUser{
            self.author = User(userPFObject: authorPFUser)
        }
        
        if let caption = postPFPbject["caption"] as? String{
            self.caption = caption
        }
        
        if let likesCount = postPFPbject["likes_count"] as? Int{
            self.likesCount = likesCount
        }
        
        if let commentsCount = postPFPbject["comments_count"] as? Int{
            self.commentsCount = commentsCount
        }
        
        self.timestamp = postPFPbject.createdAt
        
        if let location = postPFPbject["location"] as? String{
            self.location = location
        }
    }
    
    class func getArrayOfPosts(postPFObjects: [PFObject]) -> [Post] {
        var posts: [Post] = []
        
        for item in postPFObjects {
            posts.append(Post(postPFPbject: item))
        }
        return posts
    }
    
    class func createNewPost(picture: UIImage?, caption: String?, location: String?, success: @escaping (PFObject) -> Void, failure: @escaping (Error)->Void){
        
        ParseClient.sharedInstance.newPost(media: getPFFileFromImage(image: picture), caption: caption, location: location, success: { (response: PFObject) in
            success(response)
        }) { (error: Error) in
            failure(error)
        }
    }
    
    class func getPFFileFromImage(image: UIImage?)->PFFile?{
        if let image = image{
            if let pngImageData = UIImagePNGRepresentation(image) {
                return PFFile(name: "image.png", data: pngImageData)
            }
        }
        return nil
    }
    
    class func fetchPosts(success: @escaping ([Post]) -> Void, failure: @escaping (Error) -> Void){
        ParseClient.sharedInstance.getPosts(success: { (reponse: [PFObject]) in
            success(getArrayOfPosts(postPFObjects: reponse))
        }) { (error: Error) in
            failure(error)
        }
    }
    
    class func fetchUserPosts(user: PFUser, success: @escaping ([Post]) -> Void, failure: @escaping (Error) -> Void){
        ParseClient.sharedInstance.getUserPosts(user: user, success: { (response: [PFObject]) in
            success(getArrayOfPosts(postPFObjects: response))
        }) { (error: Error) in
            failure(error)
        }
    }
}
