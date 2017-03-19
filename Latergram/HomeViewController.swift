//
//  HomeViewController.swift
//  Latergram
//
//  Created by Satyam Jaiswal on 3/12/17.
//  Copyright © 2017 Satyam Jaiswal. All rights reserved.
//

import UIKit
import SVProgressHUD

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
        if self.posts == nil {
            return 0
        }else{
            return self.posts!.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        cell.post = self.posts?[indexPath.row]
        return cell
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
