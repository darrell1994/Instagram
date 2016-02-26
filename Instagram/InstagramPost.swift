//
//  InstagramPost.swift
//  Instagram
//
//  Created by Darrell Shi on 2/25/16.
//  Copyright © 2016 iOS Development. All rights reserved.
//

import Foundation
import UIKit
import Parse

class InstagramPost {
    var image: UIImage?
    var caption: String?
    
    init(image: UIImage?, caption: String?) {
        self.image = image
        self.caption = caption
    }
    
    func postImageWithCompletion(completion: PFBooleanResultBlock?) {
        let post = PFObject(className: "InstagramPost")
        post["image"] = getPFFileFromImage(image!)
        post["author"] = PFUser.currentUser() // Pointer column type that points to PFUser
        post["caption"] = caption
        post["likesCount"] = 0
        post["commentsCount"] = 0
        post.saveInBackgroundWithBlock(completion)
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
}