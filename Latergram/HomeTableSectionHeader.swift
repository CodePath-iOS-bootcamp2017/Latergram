//
//  HomeTableSectionHeader.swift
//  Latergram
//
//  Created by Satyam Jaiswal on 3/20/17.
//  Copyright © 2017 Satyam Jaiswal. All rights reserved.
//

import UIKit
import ParseUI

class HomeTableSectionHeader: UITableViewCell {

    @IBOutlet weak var profileImageView: PFImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    var sectionNumber: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    fileprivate func setupUI(){
        self.profileImageView.layer.cornerRadius = 20.0
        self.profileImageView.layer.masksToBounds = true
    }
    
}
