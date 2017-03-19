//
//  HomeViewController.swift
//  Latergram
//
//  Created by Satyam Jaiswal on 3/12/17.
//  Copyright © 2017 Satyam Jaiswal. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var homeImageView: UIImageView!
    @IBOutlet weak var uploadImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.setupGestureRecognizers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupTableView(){
        self.homeTableView.tableFooterView = UIView()
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
    
    func onUploadTapped(_ sender: Any){
        performSegue(withIdentifier: "newPostSegue", sender: sender)
    }

    func onProfileTapped(_ sender: Any) {
        performSegue(withIdentifier: "showProfileSegue", sender: sender)
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
