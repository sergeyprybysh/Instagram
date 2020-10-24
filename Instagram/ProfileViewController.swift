//
//  ProfileViewController.swift
//  Instagram
//
//  Created by Sergey Prybysh on 10/22/20.
//

import UIKit
import Parse

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var totalPostsCountLabel: UILabel!
    var currentUser: PFUser!
    var currentPosts = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        getCurrentUser()
        userNameLabel.text = currentUser["username"] as? String
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        getUserPosts()
    }
    
    func getCurrentUser() {
        guard let user = PFUser.current() else { return }
        currentUser = user
    }
    
    func getUserPosts() {
        let query = PFQuery(className: "Posts")
        guard let user = currentUser else { return }
        query.whereKey("author", equalTo: user)
        query.limit = 20

        query.findObjectsInBackground { (posts, error) in
            if posts != nil {
                self.currentPosts = posts!
                self.collectionView.reloadData()
                self.totalPostsCountLabel.text = "\(self.currentPosts.count) posts"
            } else {
                print("Error quering posts")
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        currentPosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfilePostCell", for: indexPath) as! ProfilePostCell
        let currentPost = currentPosts[indexPath.row]
        
        let imageFile = currentPost["image"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        
        cell.postImageView.af.setImage(withURL: url)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemWidth = view.frame.size.width / 3.0

        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
}
