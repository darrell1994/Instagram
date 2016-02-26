//
//  HomeViewController.swift
//  Instagram
//
//  Created by Darrell Shi on 2/23/16.
//  Copyright © 2016 iOS Development. All rights reserved.
//

import UIKit
import Parse

class HomeViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var posts: [PFObject]?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 342
        
    }
    
    override func viewDidAppear(animated: Bool) {
        fetchData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func fetchData() {
        let query = PFQuery(className: "InstagramPost")
        query.orderByDescending("createdAt")
        query.includeKey("author")
        query.limit = 20
        query.findObjectsInBackgroundWithBlock { (posts:[PFObject]?, error: NSError?) -> Void in
            if let posts = posts {
                self.posts = posts
                self.tableView.reloadData()
            }
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let posts = posts {
            return posts.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("InstagramCell") as! InstagramCell
        let post = posts![indexPath.section]
        let caption = post["caption"] as? String
        cell.captionLabel.text = caption
        if let imagePFFile = post["image"] as? PFFile {
            imagePFFile.getDataInBackgroundWithBlock({ (data, error) -> Void in
                if let data = data {
                    let image = UIImage(data: data)
                    cell.photoView.image = image
                }
            })
        }
        
        return cell
    }
}