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
    var media: PFFile?
    var author: User?
    var caption: String?
    var likesCount: Int?
    var commentsCount: Int?
    
    init(postPFPbject: PFObject) {
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
    }
    
    class func createNewPost(picture: PFFile, caption: String, success: @escaping (PFObject) -> Void, failure: @escaping (Error)->Void){
        ParseClient.sharedInstance.newPost(media: picture, caption: caption, success: { (response: PFObject) in
            success(response)
        }) { (error: Error) in
            failure(error)
        }
    }
}
