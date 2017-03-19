//
//  ProfileViewController.swift
//  Latergram
//
//  Created by Satyam Jaiswal on 3/12/17.
//  Copyright © 2017 Satyam Jaiswal. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var homeImageView: UIImageView!
    @IBOutlet weak var plusImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileCollectionView: UICollectionView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupGestureRecognizers()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupCollectionView(){
        
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
