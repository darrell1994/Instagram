//
//  LoginViewController.swift
//  Instagram
//
//  Created by Darrell Shi on 2/23/16.
//  Copyright © 2016 iOS Development. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onLogin(sender: AnyObject) {
        activityIndicator.startAnimating()
        PFUser.logInWithUsernameInBackground(usernameField.text!, password: passwordField.text!) { (user, error) -> Void in
            self.activityIndicator.stopAnimating()
            if user != nil {
                
                self.popupMessage("Logged in!", segue: true)
            } else {
                self.popupMessage("Failed to login", segue: false)
            }
        }
    }

    @IBAction func onSignup(sender: AnyObject) {
        activityIndicator.startAnimating()
        let newUser = PFUser()
        newUser.username = usernameField.text
        newUser.password = passwordField.text
        newUser.signUpInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            self.activityIndicator.stopAnimating()
            if success {
                self.popupMessage("Signed up!", segue: true)
            } else {
                self.popupMessage("Failed to sign up", segue: false)
            }
        }
    }
    
    private func popupMessage(message: String, segue: Bool) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .Alert)
        self.presentViewController(alert, animated: true) { () -> Void in
            let view = alert.view.superview
            let gesture: UITapGestureRecognizer
            if segue {
                gesture = UITapGestureRecognizer(target: self, action: "backgroundTappedAndSegue")
            } else {
                gesture = UITapGestureRecognizer(target: self, action: "backgroundTapped")
            }
            view?.addGestureRecognizer(gesture)
        }
    }
    
    func backgroundTapped() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func backgroundTappedAndSegue() {
        self.dismissViewControllerAnimated(true) { () -> Void in
            self.performSegueWithIdentifier("ToInstagramViewController", sender: nil)
        }
    }
}
