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

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var homeImageView: UIImageView!
    @IBOutlet weak var uploadImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!

    var posts: [Post]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.setupGestureRecognizers()
        self.configureRefreshControl()
        self.loadDataFromNetwork()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupTableView(){
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
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        headerView.backgroundColor = UIColor(white: 1, alpha: 0.9)
        
        let userProfileImageView = PFImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        userProfileImageView.clipsToBounds = true
        userProfileImageView.layer.cornerRadius = 15;
        userProfileImageView.layer.borderColor = UIColor(white: 0.7, alpha: 0.8).cgColor
        userProfileImageView.layer.borderWidth = 1;
        
        // setting avatar image
        userProfileImageView.file = self.posts?[section].author?.profileImage
        userProfileImageView.loadInBackground()
        headerView.addSubview(userProfileImageView)
        
        // gesture for avatar image
        let profileTapGesture = UITapGestureRecognizer()
        profileTapGesture.addTarget(self, action: #selector(onUserAvatarTapped))
        userProfileImageView.addGestureRecognizer(profileTapGesture)
        userProfileImageView.isUserInteractionEnabled = true
        
        // UILabel for the username
        let usernameLabel = UILabel()
        usernameLabel.frame = CGRect(x: 45, y: 10, width: 500, height: 30)
        //        label.clipsToBounds = true
        usernameLabel.text = self.posts?[section].author?.username
        usernameLabel.textColor = UIColor.black
        let fontSize: CGFloat = 15.0
        usernameLabel.font = usernameLabel.font.withSize(fontSize)
        headerView.addSubview(usernameLabel)
        
        // gesture for username
        let usernameTapGesture = UITapGestureRecognizer()
        usernameTapGesture.addTarget(self, action: #selector(onUsernameTapped))
        usernameLabel.addGestureRecognizer(usernameTapGesture)
        usernameLabel.isUserInteractionEnabled = true
        
        // UILabel for the timestamp
        if let date = self.posts?[section].timestamp{
            let dateLabel = UILabel()
            dateLabel.frame = CGRect(x: UIScreen.main.bounds.width-20.0, y: 10, width: 200, height: 30)
            //        label.clipsToBounds = true
            dateLabel.text = Date().offsetFrom(date)
            dateLabel.textColor = UIColor.gray
            let dateFontSize: CGFloat = 12.0
            dateLabel.font = dateLabel.font.withSize(dateFontSize)
            headerView.addSubview(dateLabel)
        }
        
        return headerView
    }
    
    func setupGestureRecognizers(){
        let uploadTapGesture = UITapGestureRecognizer()
        uploadTapGesture.addTarget(self, action: #selector(onUploadTapped))
        self.uploadImageView.addGestureRecognizer(uploadTapGesture)
        self.uploadImageView.isUserInteractionEnabled = true
        
        let profileTapGesture = UITapGestureRecognizer()
        profileTapGesture.addTarget(self, action: #selector(onProfileTapped))
        self.profileImageView.addGestureRecognizer(profileTapGesture)
        self.profileImageView.isUserInteractionEnabled = true
    }
    
    func configureRefreshControl(){
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
    
    func loadDataFromNetwork(){
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
                if let tappedView = gestureRecognizer.view{
                    if let cell = tappedView.superview?.superview as? HomeTableViewCell{
                        if let indexPath = self.homeTableView.indexPath(for: cell) {
                            let nc = segue.destination as! UINavigationController
                            let vc = nc.topViewController as! ProfileViewController
                            vc.userId = self.posts?[indexPath.section].author?.id
                        }
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
