//
//  HomeTableViewCell.swift
//  Latergram
//
//  Created by Satyam Jaiswal on 3/18/17.
//  Copyright © 2017 Satyam Jaiswal. All rights reserved.
//

import UIKit
import ParseUI

class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postImageView: PFImageView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var postImageHeightContraint: NSLayoutConstraint!
    
    var post: Post?{
        didSet{
            if let post = post{
                if let postMedia = post.media{
                    self.postImageView.file = postMedia
                    self.postImageView.loadInBackground()
                }
                
                if let caption = post.caption{
                    self.captionLabel.text = caption
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
