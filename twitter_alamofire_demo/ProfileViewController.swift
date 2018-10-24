//
//  ProfileViewController.swift
//  twitter_alamofire_demo
//
//  Created by LinuxPlus on 10/23/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var joinedLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var segmentedContainerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tweetsLabel: UILabel!
    var tweets: [Tweet] = []
    var refreshControl: UIRefreshControl!
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL(string: User.current!.profile_image_url_https!)
        let data = try! Data(contentsOf: url!)
        profileImageView.image = UIImage(data: data)
        
        nameLabel.text = User.current?.name
        usernameLabel.text = "@\(String(describing: User.current!.screenName!))"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
        guard let date = dateFormatter.date(from: (User.current?.createdAt!)!) else {
            fatalError("ERROR: Date conversion failed due to mismatched format.")
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        let displayDate = formatter.string(from: date)
        
        joinedLabel.text = "Joined \(displayDate)"
        followingLabel.text = "\(String(describing: User.current!.followingCount!))"
        followersLabel.text = "\(String(describing: User.current!.followersCount!))"
        tweetsLabel.text = "\(String(describing: User.current!.tweetCount!))"
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(didPullToRefresh(_:)), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        getUserTweets()
    }
    
    @objc func didPullToRefresh(_ refreshControl: UIRefreshControl){
        getUserTweets()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        cell.tweet = tweets[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func getUserTweets(){
        activityIndicator.startAnimating()
        APIManager.shared.getHomeTimeLine { (tweet: [Tweet]?,error: Error?) in
            if let tweet = tweet{
                self.tweets = tweet
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
                self.refreshControl.endRefreshing()
            }else{
                print("error: ", error?.localizedDescription ?? "Unknown" )
            }
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
