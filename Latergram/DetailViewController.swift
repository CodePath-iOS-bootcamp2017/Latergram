//
//  DetailViewController.swift
//  Latergram
//
//  Created by Satyam Jaiswal on 3/21/17.
//  Copyright © 2017 Satyam Jaiswal. All rights reserved.
//

import UIKit
import ParseUI

class DetailViewController: UIViewController {

    @IBOutlet weak var profileImageView: PFImageView!
    @IBOutlet weak var postImageView: PFImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    @IBOutlet weak var postImageHeightContraint: NSLayoutConstraint!
    var post: Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func updateUI(){
        if let post = self.post{
            if let profileImageFile = post.author?.profileImage{
                self.profileImageView.file = profileImageFile
                self.profileImageView.layer.cornerRadius = 20.0
                self.profileImageView.layer.masksToBounds = true
                self.profileImageView.loadInBackground()
            }
            
            if let postImageFile = post.media{
                self.postImageHeightContraint.constant = UIScreen.main.bounds.width
                self.postImageView.file = postImageFile
                self.postImageView.loadInBackground()
            }
            
            if let username = post.author?.username{
                self.usernameLabel.text = username
            }
            
            if let location = self.post?.location{
                self.locationLabel.text = location
            }
            
            if let caption = self.post?.caption{
                self.captionLabel.text = caption
            }
            
            if let timestamp = post.timestamp{
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                formatter.timeStyle = .none
                self.timestampLabel.text = formatter.string(from: timestamp)
            }
        }
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
