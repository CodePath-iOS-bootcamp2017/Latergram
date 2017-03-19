//
//  ProfileCollectionReusableView.swift
//  Latergram
//
//  Created by Satyam Jaiswal on 3/18/17.
//  Copyright © 2017 Satyam Jaiswal. All rights reserved.
//

import UIKit
import ParseUI

class ProfileCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var userProfileImageView: PFImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var postCountLabel: UILabel!
    @IBOutlet weak var EditProfileButton: UIButton!
}
