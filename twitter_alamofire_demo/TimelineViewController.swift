//
//  TimelineViewController.swift
//  twitter_alamofire_demo
//
//  Created by Aristotle on 2018-08-11.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ComposeViewControllerDelegate {

    func did(post: Tweet) {
        self.getTweets()
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var refresh = UIRefreshControl()
    var tweets: [Tweet] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        getTweets()
        
        tableView.dataSource = self
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        
        
        refresh.addTarget(self, action: #selector(didPullToRefresh(_:)), for: .valueChanged)
        didPullToRefresh(refresh)
        tableView.insertSubview(refresh, at: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogoutButton(_ sender: Any) {
        APIManager.shared.logout()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        cell.tweet = tweets[indexPath.row]
        return cell
    }
    
    @objc func didPullToRefresh(_ refreshControl: UIRefreshControl){
        getTweets()
    }
    func getTweets(){
        
        activityIndicator.startAnimating()
        APIManager.shared.getHomeTimeLine { (tweet: [Tweet]?,error: Error?) in
            if let tweet = tweet{
                self.tweets = tweet
                self.tableView.reloadData()
                self.refresh.endRefreshing()
                self.activityIndicator.stopAnimating()            }else{
                print("error: ", error?.localizedDescription ?? "Unknown" )
            }
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let tweetDetailViewController = segue.destination as? TweetDetailViewController{
            let cell = sender as! UITableViewCell
            if let indexPath = tableView.indexPath(for: cell){
                let tweet = tweets[indexPath.row]
                tweetDetailViewController.tweet = tweet
            }
        }
        
        if let composeViewController = segue.destination as? ComposeViewController{
            //composeViewController.delegate = self
        }
        
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
