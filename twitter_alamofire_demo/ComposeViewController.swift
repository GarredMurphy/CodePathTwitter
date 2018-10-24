//
//  ComposeViewController.swift
//  twitter_alamofire_demo
//
//  Created by LinuxPlus on 10/16/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit

protocol ComposeViewControllerDelegate {
    func did(post: Tweet)
}

class ComposeViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var composeTextView: UITextView!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postButton: UIButton!
    @IBAction func onPostButton(_ sender: Any) {
        if composeTextView.text.isEmpty == false && composeTextView.textColor == .black{
            APIManager.shared.composeTweet(with: composeTextView.text) { (tweet, error) in
                if let error = error {
                    print("Error composing Tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    self.delegate?.did(post: tweet)
                    print("Compose Tweet Success!")
                }
            }
            dismiss(animated: true, completion: nil)
        }
    }
    
    let characterLimitLabel = UILabel()
    var characterLimit = 140
    
    let navigationBar: UINavigationBar = {
        let bar = UINavigationBar()
        bar.topItem?.title = "Tweet"
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()
    
    var delegate: ComposeViewControllerDelegate?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: User.current!.profile_image_url_https!)
        let data = try! Data(contentsOf: url!)
        profileImageView.image = UIImage(data: data)
        
        usernameLabel.text = User.current?.name
        authorLabel.text = User.current?.screenName
        
        composeTextView.text = "- - - - - - - "
        composeTextView.textColor = .lightGray
        composeTextView.delegate = self
        
        layout()
    }
    
    func layout(){
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
        
        characterLimitLabel.translatesAutoresizingMaskIntoConstraints = false
        customView.addSubview(characterLimitLabel)
        characterLimitLabel.centerXAnchor.constraint(equalTo: customView.centerXAnchor).isActive = true
        characterLimitLabel.centerYAnchor.constraint(equalTo: customView.centerYAnchor).isActive = true
        characterLimitLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        characterLimitLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        characterLimitLabel.text = "\(characterLimit)"
        
        composeTextView.inputAccessoryView = customView
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray{
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        characterLimit = 140 - textView.text.count
        if characterLimit >= 0{
            postButton.isEnabled = true
            if characterLimit <= 20{
                characterLimitLabel.textColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            }
        }
        else if characterLimit < 0{
            postButton.isEnabled = false
            characterLimitLabel.textColor = #colorLiteral(red: 0.7667433216, green: 0.07178737335, blue: 0, alpha: 1)
        }
        characterLimitLabel.text = "\(characterLimit)"
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty{
            textView.text = "- - - - - - "
            textView.textColor = .lightGray
        }
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
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
