//
//  ProfileViewController.swift
//  Latergram
//
//  Created by Satyam Jaiswal on 3/12/17.
//  Copyright © 2017 Satyam Jaiswal. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var homeImageView: UIImageView!
    @IBOutlet weak var plusImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileCollectionView: UICollectionView!

    var userId: String?
    var userPosts: [Post]?
    var user: PFUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupGestureRecognizers()
        self.setupCollectionView()
        self.loadUserData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupCollectionView(){
        self.profileCollectionView.delegate = self
        self.profileCollectionView.dataSource = self
        self.profileCollectionView.register(ProfileCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "HeaderView")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.userPosts == nil{
            return 0
        }else{
            return self.userPosts!.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCollectionViewCell", for: indexPath) as! ProfileCollectionViewCell
        cell.postImageView.file = self.userPosts?[indexPath.row].media
        cell.postImageView.loadInBackground()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "HeaderView", for: indexPath) as! ProfileCollectionReusableView
        
        if let user = self.user{
            let user = User(userPFObject: user)
            if let name = user.name {
                headerView.nameLabel.text = name
            }
            
            if let profileImage = user.profileImage{
                headerView.userProfileImageView.file = profileImage
                headerView.userProfileImageView.loadInBackground()
            }
            
            if let bio = user.bio{
                headerView.descriptionLabel.text = bio
            }
        }
        return headerView
    }
    
    func setupGestureRecognizers(){
        let plusGesture = UITapGestureRecognizer()
        plusGesture.addTarget(self, action: #selector(onPlusTapped))
        self.plusImageView.addGestureRecognizer(plusGesture)
        self.plusImageView.isUserInteractionEnabled = true
     
        let homeGesture = UITapGestureRecognizer()
        homeGesture.addTarget(self, action: #selector(onHomeTapped))
        self.homeImageView.addGestureRecognizer(homeGesture)
        self.homeImageView.isUserInteractionEnabled = true
    }
    
    func onPlusTapped(_ sender: Any) {
        performSegue(withIdentifier: "newPostSegue", sender: sender)
    }
    
    func onHomeTapped(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    func loadUserData(){
        if let userId = self.userId{
            ParseClient.sharedInstance.getUser(userId: userId, success: { (user: PFUser) in
                self.user = user
                self.loadUserPosts(user: user)
            }, failure: { (error: Error) in
                print("Error getting the user: \(error.localizedDescription)")
            })
        }else{
            self.user = PFUser.current()!
            loadUserPosts(user: PFUser.current()!)
        }
    }
    
    func loadUserPosts(user: PFUser){
        Post.fetchUserPosts(user: user, success: { (response: [Post]) in
            self.userPosts = response
            self.profileCollectionView.reloadData()
        }) { (error: Error) in
            print("Error in fetching user posts: \(error.localizedDescription)")
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
