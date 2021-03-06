//
//  ProfileViewController.swift
//  Latergram
//
//  Created by Satyam Jaiswal on 3/12/17.
//  Copyright © 2017 Satyam Jaiswal. All rights reserved.
//

import UIKit
import Parse
import SVProgressHUD

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var homeImageView: UIImageView!
    @IBOutlet weak var plusImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileCollectionView: UICollectionView!
    @IBOutlet weak var profileCollectionFlowLayout: UICollectionViewFlowLayout!
    var userId: String?
    var userPosts: [Post]?
    var user: PFUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupGestureRecognizers()
        self.setupCollectionView()
        self.loadUserData()
    }

    override func viewDidAppear(_ animated: Bool) {
        self.loadUserData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func setupCollectionView(){
        self.profileCollectionView.delegate = self
        self.profileCollectionView.dataSource = self
        
        self.profileCollectionFlowLayout.scrollDirection = .vertical
        self.profileCollectionFlowLayout.minimumInteritemSpacing = 2
        self.profileCollectionFlowLayout.minimumLineSpacing = 2
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width/3 - 2.0
        return CGSize(width: width, height: width)
        
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
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "ProfileCollectionReusableView", for: indexPath) as! ProfileCollectionReusableView
        
        if let user = self.user{
            let user = User(userPFObject: user)
            if let name = user.name {
                headerView.nameLabel.isHidden = false
                headerView.nameLabel.text = name
            }else{
                headerView.nameLabel.isHidden = true
            }
            
            if let profileImage = user.profileImage{
                headerView.userProfileImageView.file = profileImage
                headerView.userProfileImageView.loadInBackground()
            }else{
                headerView.userProfileImageView.image = UIImage(named: "avatar")
            }
            headerView.userProfileImageView.layer.cornerRadius = 50.0
            headerView.userProfileImageView.layer.masksToBounds = true
            
            if let bio = user.bio{
                headerView.descriptionLabel.isHidden = false
                headerView.descriptionLabel.text = bio
            }else{
                headerView.descriptionLabel.isHidden = true
            }
            
            if self.user?.objectId == PFUser.current()?.objectId{
                self.activateProfile()
                headerView.EditProfileButton.isHidden = false
                headerView.EditProfileButton.layer.borderWidth = 1.0
                headerView.EditProfileButton.layer.borderColor = UIColor.gray.cgColor
                headerView.EditProfileButton.layer.cornerRadius = 5
                headerView.EditProfileButton.layer.masksToBounds = true
            }else{
                headerView.EditProfileButton.isHidden = true
            }
            
            ParseClient.sharedInstance.getUserPostCount(user: self.user!, success: { (postCount: Int) in
                headerView.postCountLabel.text = "\(postCount)"
            }, failure: { (error: Error) in
                print("Error getting post count: \(error.localizedDescription)")
                headerView.postCountLabel.text = "--"
            })
            
        }
        return headerView
    }
    
    fileprivate func setupGestureRecognizers(){
        let plusGesture = UITapGestureRecognizer()
        plusGesture.addTarget(self, action: #selector(onPlusTapped))
        self.plusImageView.addGestureRecognizer(plusGesture)
        self.plusImageView.isUserInteractionEnabled = true
     
        let homeGesture = UITapGestureRecognizer()
        homeGesture.addTarget(self, action: #selector(onHomeTapped))
        self.homeImageView.addGestureRecognizer(homeGesture)
        self.homeImageView.isUserInteractionEnabled = true
        
        let profileGesture = UITapGestureRecognizer()
        profileGesture.addTarget(self, action: #selector(onProfileTapped))
        self.profileImageView.addGestureRecognizer(profileGesture)
        self.profileImageView.isUserInteractionEnabled = true
    }
    
    func onPlusTapped(_ sender: Any) {
        performSegue(withIdentifier: "newPostSegue", sender: sender)
    }
    
    func onHomeTapped(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    func onProfileTapped(_ sender: Any) {
        self.userId = PFUser.current()?.objectId
        self.user = PFUser.current()
        self.loadUserData()
    }
    
    fileprivate func loadUserData(){
        SVProgressHUD.show()
        if let userId = self.userId{
            ParseClient.sharedInstance.getUser(userId: userId, success: { (user: PFUser) in
                self.user = user
                self.loadUserPosts(user: user)
            }, failure: { (error: Error) in
                print("Error getting the user: \(error.localizedDescription)")
            })
        }else{
            self.user = PFUser.current()
            self.userId = PFUser.current()?.objectId
            loadUserPosts(user: PFUser.current()!)
            self.setupLogoutButton()
            self.activateProfile()
        }
    }
    
    fileprivate func loadUserPosts(user: PFUser){
        self.setupNavigationBar()
        Post.fetchUserPosts(user: user, success: { (response: [Post]) in
            self.userPosts = response
            self.profileCollectionView.reloadData()
            SVProgressHUD.dismiss()
        }) { (error: Error) in
            print("Error in fetching user posts: \(error.localizedDescription)")
            SVProgressHUD.dismiss()
        }
    }
    
    fileprivate func activateProfile(){
        self.homeImageView.image = UIImage(named: "home")
        self.profileImageView.image = UIImage(named: "profile_black")
        self.plusImageView.image = UIImage(named: "plus")
    }
    
    fileprivate func setupLogoutButton(){
//        print("setupLogoutButton")
        let logoutButton = UIButton(type: UIButtonType.system)
        logoutButton.setTitle("logout", for: UIControlState.normal)
        logoutButton.frame = CGRect(x: 0, y: 0, width: 50.0, height: 25.0)
        logoutButton.addTarget(self, action: #selector(onLogoutTapped), for: UIControlEvents.touchDown)
        logoutButton.isUserInteractionEnabled = true
        let rightBarButtonItem = UIBarButtonItem()
        rightBarButtonItem.customView = logoutButton
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    func onLogoutTapped(_ sender: Any){
        PFUser.logOut()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "User_Logged_out"), object: nil)
    }
    
    fileprivate func setupNavigationBar(){
        let titleView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: 300, height: 30)
        let titleLabel = UILabel()
        titleLabel.text = self.user?.username
        
        if self.userId == PFUser.current()?.objectId{
            titleLabel.frame = CGRect(x: 5, y: 5, width: 200, height: 30)
        }else{
            titleLabel.frame = CGRect(x: 50, y: 5, width: 200, height: 30)
            
            let closeImageView = UIImageView(image: UIImage(named: "close"))
            closeImageView.frame = CGRect(x: 0, y: 5, width: 25, height: 25)
            titleView.addSubview(closeImageView)
            
            let closeTapGesture = UITapGestureRecognizer()
            closeTapGesture.addTarget(self, action: #selector(onCloseTapped))
            closeImageView.addGestureRecognizer(closeTapGesture)
            closeImageView.isUserInteractionEnabled = true
        }
        
        titleView.addSubview(titleLabel)
        
        
        let leftBarButton = UIBarButtonItem()
        leftBarButton.customView = titleView
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    func onCloseTapped(_ sender: Any){
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if SVProgressHUD.isVisible(){
            SVProgressHUD.dismiss()
        }
        
        if segue.identifier == "detailsSegue" {
            let detailViewController = segue.destination as! DetailViewController
            let cell = sender as! ProfileCollectionViewCell
            if let indexpath = self.profileCollectionView.indexPath(for: cell){
                detailViewController.post = self.userPosts?[indexpath.row]
            }
            
        }
    }
    

}
