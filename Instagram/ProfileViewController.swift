//
//  ProfileViewController.swift
//  Instagram
//
//  Created by Darrell Shi on 2/23/16.
//  Copyright © 2016 iOS Development. All rights reserved.
//

import UIKit
import Parse
import BFRadialWaveHUD

let userLogoutNotification = "userLogoutNotification"

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var profileImageView: UIImageView!
    var loadingHUD: BFRadialWaveHUD?

    override func viewDidLoad() {
        super.viewDidLoad()

        loadingHUD = BFRadialWaveHUD(view: view, fullScreen: true, circles: 20, circleColor: UIColor.whiteColor(), mode: BFRadialWaveHUDMode.Default, strokeWidth: 1)
        
        let user = PFUser.currentUser()
        if let profileData = user?["profile"] as? NSData {
            let image = UIImage(data: profileData)
            profileImageView.image = image
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogout(sender: AnyObject) {
        PFUser.logOut()
        NSNotificationCenter.defaultCenter().postNotificationName(userLogoutNotification, object: nil)
    }
    
    @IBAction func onAddProfile(sender: AnyObject) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .Default, handler: { (action: UIAlertAction) -> Void in
            let vc = UIImagePickerController()
            vc.delegate = self
            vc.allowsEditing = true
            vc.sourceType = UIImagePickerControllerSourceType.Camera
            self.presentViewController(vc, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Photo Library", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction) -> Void in
            let vc = UIImagePickerController()
            vc.delegate = self
            vc.allowsEditing = true
            vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(vc, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let edited = info[UIImagePickerControllerEditedImage] as! UIImage
        profileImageView.image = edited
        picker.dismissViewControllerAnimated(true, completion: nil)
        self.onChangeProfile()
    }

     func onChangeProfile() {
        loadingHUD?.show()
        let profileImage = resizeImage(profileImageView.image!, newSize: CGSize(width: 128, height: 128))
        let user = PFUser.currentUser()
        if let imageData = UIImagePNGRepresentation(profileImage) {
            user!["profile"] = imageData
//            let pffile = PFFile(name: "image.png", data: imageData)
//            user?.addObject(pffile!, forKey: "profile_image")
            user?.saveInBackgroundWithBlock({ (success, error) -> Void in
                self.loadingHUD?.dismiss()
                if success {
                    self.popupMessage("Profile uploaded!")
                } else {
                    self.popupMessage("Failed to upload profile image")
                    print(error.debugDescription)
                }
            })
        }
    }
    
    func resizeImage(image: UIImage, newSize: CGSize) -> UIImage {
        let resizeImageView = UIImageView(frame: CGRectMake(0, 0, newSize.width, newSize.height))
        resizeImageView.contentMode = UIViewContentMode.ScaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    private func popupMessage(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .Alert)
        self.presentViewController(alert, animated: true) { () -> Void in
            let view = alert.view.superview
            let gesture = UITapGestureRecognizer(target: self, action: "backgroundTapped")
            view?.addGestureRecognizer(gesture)
        }
    }
    
    func backgroundTapped() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func getPFFileFromImage(image: UIImage?) -> PFFile? {
        // check if image is not nil
        if let image = image {
            // get image data and check if that is not nil
            if let imageData = UIImagePNGRepresentation(image) {
                return PFFile(name: "image.png", data: imageData)
            }
        }
        return nil
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
