//
//  HomeViewController.swift
//  Latergram
//
//  Created by Satyam Jaiswal on 3/12/17.
//  Copyright © 2017 Satyam Jaiswal. All rights reserved.
//

import UIKit
import SVProgressHUD
import ParseUI

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NewPostDelegate {

    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var homeImageView: UIImageView!
    @IBOutlet weak var uploadImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!

    var posts: [Post]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onNewPostShare(newPost: Post) {
        self.posts?.insert(newPost, at: 0)
        self.homeTableView.reloadData()
    }
    
    fileprivate func setupUI(){
        self.navigationItem.title = "Latergram"
        self.setupTableView()
        self.setupGestureRecognizers()
        self.configureRefreshControl()
        self.loadDataFromNetwork()
    }
    
    fileprivate func setupTableView(){
        self.homeTableView.tableFooterView = UIView()
        self.homeTableView.delegate = self
        self.homeTableView.dataSource = self
        
        self.homeTableView.estimatedRowHeight = 120
        self.homeTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        cell.post = self.posts?[indexPath.section]
        cell.postImageHeightContraint.constant = UIScreen.main.bounds.width
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.posts == nil {
            return 0
        }else{
            return self.posts!.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = Bundle.main.loadNibNamed("HomeTableSectionHeader", owner: self, options: nil)?.first as! HomeTableSectionHeader
        headerView.sectionNumber = section
        
        if let post = self.posts?[section]{
            if let profileImageFile = post.author?.profileImage{
                headerView.profileImageView.file = profileImageFile
                headerView.profileImageView.loadInBackground()
            }
            
            if let username = post.author?.username{
                headerView.usernameLabel.text = username
            }
            
            if let location = post.location{
                headerView.locationLabel.isHidden = false
                headerView.locationLabel.text = location
            }else{
                headerView.locationLabel.isHidden = true
            }
            
            if let timestamp = post.timestamp{
                headerView.timestampLabel.text = Date().offsetFrom(timestamp)
            }
        }
        
        // gesture for avatar image
        let profileTapGesture = UITapGestureRecognizer()
        profileTapGesture.addTarget(self, action: #selector(onUserAvatarTapped))
        headerView.profileImageView.addGestureRecognizer(profileTapGesture)
        headerView.profileImageView.isUserInteractionEnabled = true

        // gesture for username
        let usernameTapGesture = UITapGestureRecognizer()
        usernameTapGesture.addTarget(self, action: #selector(onUsernameTapped))
        headerView.usernameLabel.addGestureRecognizer(usernameTapGesture)
        headerView.usernameLabel.isUserInteractionEnabled = true
        
        
        return headerView
    }
    
    fileprivate func setupGestureRecognizers(){
        let uploadTapGesture = UITapGestureRecognizer()
        uploadTapGesture.addTarget(self, action: #selector(onUploadTapped))
        self.uploadImageView.addGestureRecognizer(uploadTapGesture)
        self.uploadImageView.isUserInteractionEnabled = true
        
        let profileTapGesture = UITapGestureRecognizer()
        profileTapGesture.addTarget(self, action: #selector(onProfileTapped))
        self.profileImageView.addGestureRecognizer(profileTapGesture)
        self.profileImageView.isUserInteractionEnabled = true
    }
    
    fileprivate func configureRefreshControl(){
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(onRefresh), for: UIControlEvents.valueChanged)
        self.homeTableView.insertSubview(refreshControl, at: 0)
    }
    
    func onRefresh(refreshControl: UIRefreshControl){
        self.loadDataFromNetwork()
        refreshControl.endRefreshing()
    }
    
    func onUploadTapped(_ sender: Any){
        performSegue(withIdentifier: "newPostSegue", sender: sender)
    }

    func onProfileTapped(_ sender: Any) {
        performSegue(withIdentifier: "showProfileSegue", sender: sender)
    }
    
    func onUserAvatarTapped(_ sender: Any){
        print("onUserAvatarTapped")
        performSegue(withIdentifier: "showProfileSegue", sender: sender)
    }
    
    func onUsernameTapped(_ sender: Any){
        print("onUsernameTapped")
        performSegue(withIdentifier: "showProfileSegue", sender: sender)
    }
    
    fileprivate func loadDataFromNetwork(){
        SVProgressHUD.show()
        Post.fetchPosts(success: { (response: [Post]) in
            self.posts = response
            self.homeTableView.reloadData()
            SVProgressHUD.dismiss()
        }) { (error: Error) in
            print("Error fetching posts: \(error.localizedDescription)")
            SVProgressHUD.dismiss()
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if SVProgressHUD.isVisible() {
            SVProgressHUD.dismiss()
        }
        
        if segue.identifier == "showProfileSegue" {
            if let gestureRecognizer = sender as? UITapGestureRecognizer{
                let tappedView = gestureRecognizer.view
                if let header = tappedView?.superview?.superview as? HomeTableSectionHeader {
                    print("section number: \(header.sectionNumber)")
                    if let index = header.sectionNumber {
                        let nc = segue.destination as! UINavigationController
                        let vc = nc.topViewController as! ProfileViewController
                        vc.userId = self.posts?[index].author?.id
                    }
                    
                }
            }
        }else if segue.identifier == "newPostSegue" {
            if let tnc = segue.destination as? UITabBarController {
                let ncs = tnc.viewControllers
                for nc in ncs! {
                    let navigationController = nc as! UINavigationController
                    if let galleryViewController = navigationController.topViewController as? GalleryViewController{
                        galleryViewController.delegate = self
                    }else if let cameraViewController = navigationController.topViewController as? CameraViewController {
                        cameraViewController.delegate = self
                    }
                }
            }
        }
    }
}

extension Date {
    func yearsFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.year, from: date, to: self, options: []).year!
    }
    func monthsFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.month, from: date, to: self, options: []).month!
    }
    func weeksFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.weekOfYear, from: date, to: self, options: []).weekOfYear!
    }
    func daysFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.day, from: date, to: self, options: []).day!
    }
    func hoursFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.hour, from: date, to: self, options: []).hour!
    }
    func minutesFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.minute, from: date, to: self, options: []).minute!
    }
    func secondsFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.second, from: date, to: self, options: []).second!
    }
    func offsetFrom(_ date:Date) -> String {
        
        if yearsFrom(date)   > 0 { return "\(yearsFrom(date))y"   }
        if monthsFrom(date)  > 0 { return "\(monthsFrom(date))M"  }
        if weeksFrom(date)   > 0 { return "\(weeksFrom(date))w"   }
        if daysFrom(date)    > 0 { return "\(daysFrom(date))d"    }
        if hoursFrom(date)   > 0 { return "\(hoursFrom(date))h"   }
        if minutesFrom(date) > 0 { return "\(minutesFrom(date))m" }
        if secondsFrom(date) > 0 { return "\(secondsFrom(date))s" }
        return ""
    }
}
