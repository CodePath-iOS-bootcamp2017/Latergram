//
//  AlertView.swift
//  Latergram
//
//  Created by Satyam Jaiswal on 3/19/17.
//  Copyright © 2017 Satyam Jaiswal. All rights reserved.
//

import UIKit

class AlertView: NSObject {
    static let sharedInstance = AlertView()
    
    let alertController = UIAlertController(title: "Title", message: "message", preferredStyle: .alert)
    
    func setupAlertController(){
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction) in
        }
        self.alertController.addAction(OKAction)
    }
    
    func presentAlertController(viewController: UIViewController, title: String, message: String){
        self.setupAlertController()
        self.alertController.title = title
        self.alertController.message = message
        viewController.present(self.alertController, animated: true, completion: nil)
    }
}
