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
    var refresh: UIRefreshControl?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        refresh = UIRefreshControl()
        refresh?.addTarget(self, action: "onRefresh", forControlEvents: .ValueChanged)
        tableView.insertSubview(refresh!, atIndex: 0)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 342
    }
    
    func onRefresh() {
        fetchData()
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
            self.refresh?.endRefreshing()
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
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 50))
        headerView.backgroundColor = UIColor(white: 1, alpha: 0.9)
        
        if let post = posts?[section] {
            let user = post["author"] as! PFUser
            let usernameLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 200, height: 30))
            usernameLabel.text = user.username
            
            if let time = post.createdAt {
                let formatter = NSDateFormatter()
                formatter.dateStyle = NSDateFormatterStyle.ShortStyle
                formatter.timeStyle = NSDateFormatterStyle.ShortStyle
                let timeLabel = UILabel(frame: CGRect(x: 230, y: 0, width: 200, height: 30))
                timeLabel.text = formatter.stringFromDate(time)
//                timeLabel.sizeToFit()
                headerView.addSubview(timeLabel)
//                let timeConstraint_x = NSLayoutConstraint(item: headerView, attribute: .Trailing, relatedBy: .Equal, toItem: timeLabel, attribute: .Trailing, multiplier: 1, constant: 10)
//                let timeConstraint_y = NSLayoutConstraint(item: timeLabel, attribute: .CenterY, relatedBy: .Equal, toItem: headerView, attribute: .CenterY, multiplier: 1, constant: 0)
//                headerView.addConstraints([timeConstraint_x, timeConstraint_y])
                
                if let profileData = user["profile"] as? NSData {
                    let image = UIImage(data: profileData)
                    let profileImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
                    profileImageView.image = image
                    profileImageView.contentMode = UIViewContentMode.ScaleAspectFill
                    profileImageView.clipsToBounds = true
                    profileImageView.layer.cornerRadius = 22
                    profileImageView.layer.borderColor = UIColor(white: 0.7, alpha: 0.8).CGColor
                    profileImageView.layer.borderWidth = 1
                    headerView.addSubview(profileImageView)
                }
            }
            
            headerView.addSubview(usernameLabel)
        }
        
        return headerView
    }
}