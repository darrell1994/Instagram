//
//  CaptureViewController.swift
//  Instagram
//
//  Created by Darrell Shi on 2/23/16.
//  Copyright © 2016 iOS Development. All rights reserved.
//

import UIKit
import Parse
import BFRadialWaveHUD

class CaptureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var captionTextField: UITextView!
    var loadingHUD: BFRadialWaveHUD?

    override func viewDidLoad() {
        super.viewDidLoad()

        captionTextField.delegate = self
        
        loadingHUD = BFRadialWaveHUD(view: view, fullScreen: true, circles: 20, circleColor: UIColor.whiteColor(), mode: BFRadialWaveHUDMode.Default, strokeWidth: 1)
        
        let recogonizer = UITapGestureRecognizer(target: self, action: "onAddImage")
        photoView.addGestureRecognizer(recogonizer)
    
    }
    
    func onAddImage() {
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
    
    @IBAction func onUpload(sender: AnyObject) {
        loadingHUD?.show()
        let post = InstagramPost(image: photoView.image, caption: captionTextField.text)
        post.postImageWithCompletion { (success, error) -> Void in
            self.loadingHUD?.dismiss()
            if success {
                let popup = UIAlertController(title: "Image uploaded!", message: nil, preferredStyle: .Alert)
                popup.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                self.presentViewController(popup, animated: true, completion: { () -> Void in
                    self.photoView.image = UIImage(named: "add_image.png")
                    self.captionTextField.text = "Add caption here..."
                })
            } else {
                print(error.debugDescription)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let edited = info[UIImagePickerControllerEditedImage] as! UIImage
        photoView.image = edited
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func postImageWithCaption(image: UIImage?, withCaption caption: String?, withCompletion completion: PFBooleanResultBlock?) {
        
    }
}

extension CaptureViewController: UITextViewDelegate {
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.text! == "Add caption here..." {
            textView.text = ""
        }
        let gesture = UITapGestureRecognizer(target: self, action: "backgroundTapped")
        textView.superview?.addGestureRecognizer(gesture)
    }
    
    func backgroundTapped() {
        captionTextField.endEditing(true)
    }
}
