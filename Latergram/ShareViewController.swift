//
//  ShareViewController.swift
//  Latergram
//
//  Created by Satyam Jaiswal on 3/16/17.
//  Copyright © 2017 Satyam Jaiswal. All rights reserved.
//

import UIKit

class ShareViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var locationTextField: UITextField!
    
    var captionPlaceholderLabel = UILabel()
    var shareImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUI(){
        self.configureTextView()
        if let image = self.shareImage{
            self.postImageView.image = image
        }
    }
    
    func configureTextView(){
        self.captionTextView.delegate = self
        self.captionTextView.text = ""
        self.captionPlaceholderLabel.text = "Add a caption"
        self.captionPlaceholderLabel.font = UIFont.italicSystemFont(ofSize: (self.captionTextView.font?.pointSize)!)
        self.captionPlaceholderLabel.sizeToFit()
        self.captionPlaceholderLabel.textColor = UIColor(white: 0, alpha: 0.3)
        self.captionPlaceholderLabel.frame.origin = CGPoint(x: 5, y: (self.captionTextView.font?.pointSize)!/2)
        self.captionTextView.addSubview(self.captionPlaceholderLabel)
    }

    func textViewDidChange(_ textView: UITextView) {
         self.captionPlaceholderLabel.isHidden = !textView.text.isEmpty
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
