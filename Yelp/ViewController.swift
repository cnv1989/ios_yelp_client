//
//  ViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 9/19/14.
//  Copyright (c) 2014 Timothy Lee. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var client: YelpClient!
    
    // Refrencing outlets
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!

    // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
    let yelpConsumerKey = "sAwNps3nGeOkNrB2By_dvg"
    let yelpConsumerSecret = "onzreryAqeJsRSWdQNg8yeiZ8v8"
    let yelpToken = "lD_ATQydTA9D0jXsUXf81WObL0QHSw_B"
    let yelpTokenSecret = "cyiJqOz490lVha2ncnOdlMXTmoI"
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initYelpClient() {
        self.client = YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, accessToken: yelpToken, accessSecret: yelpTokenSecret)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initYelpClient()
        self.initActivityIndicator()
    }
    
    func initActivityIndicator() {
        self.activityIndicator.startAnimating()
    }
    
    func hasConnectivity() -> Bool {
        var st = false
        AFNetworkReachabilityManager.sharedManager().setReachabilityStatusChangeBlock{(status: AFNetworkReachabilityStatus?)          in
            
            switch status!.hashValue{
            case AFNetworkReachabilityStatus.NotReachable.hashValue:
                st = false
                println("Not reachable")
            case AFNetworkReachabilityStatus.ReachableViaWiFi.hashValue , AFNetworkReachabilityStatus.ReachableViaWWAN.hashValue :
                st = true
                println("Reachable")
                println(self.description)  // Seems to cause error
            default:
                st = false
                println("Unknown status")
            }
        }
        return st
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "")
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
    
    
    func updateSearchList() -> Void {
        client.searchWithTerm("Thai", success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            if response == nil {
                if self.hasConnectivity() == false {
                } else {
                }
                self.activityIndicator.stopAnimating()
                return
            }
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println(error)
        }
    }
    
}

