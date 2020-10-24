//
//  FeedViewController.swift
//  Instagram
//
//  Created by Sergey Prybysh on 10/21/20.
//

import UIKit
import Parse
import AlamofireImage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var refreshControl = UIRefreshControl()
    @IBOutlet weak var tableView: UITableView!
    var posts = [PFObject]()
    var numberOfPosts: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        refreshControl.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadCurrentPosts()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
        let post = posts[indexPath.row]
        let user = post["author"] as! PFUser
        
        cell.userNameLabel.text = user.username
        cell.captionLabel.text = post["caption"] as? String
        
        let imageFile = post["image"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        
        cell.photoView.af.setImage(withURL: url)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == posts.count, posts.count >= 20 {
            loadMorePosts()
        }
    }
    
    func loadPosts(numberOfPosts: Int) {
        let query = PFQuery(className: "Posts")
        query.includeKey("author")
        query.limit = numberOfPosts
        
        query.findObjectsInBackground { (posts, error) in
            if posts != nil {
                self.posts = posts!
                self.tableView.reloadData()
            } else {
                print("Error quering posts")
            }
        }
    }
    
    func loadCurrentPosts() {
        numberOfPosts = 20
        loadPosts(numberOfPosts: numberOfPosts)
    }
    
    func loadMorePosts() {
        numberOfPosts += 20
        loadPosts(numberOfPosts: numberOfPosts)
    }
    
    @objc func onRefresh() {
        loadPosts(numberOfPosts: numberOfPosts)
        self.refreshControl.endRefreshing()
    }
}
