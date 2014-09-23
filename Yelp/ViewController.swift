//
//  ViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 9/19/14.
//  Copyright (c) 2014 Timothy Lee. All rights reserved.
//

import UIKit

class SearchOptions  {
    var categories = []
    var category_filter = ""
    var radius_filter = 0
    var sort = 0
    var deals_filter = false
    var limit = 10
    var term = "food"
}

var SEARCH_OPTIONS = SearchOptions()

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIScrollViewDelegate {
    var client: YelpClient!
    
    // Refrencing outlets
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var category_filter = ""
    var radius_filter = 1000
    var sort = 0
    var deals_filter = false
    var limit = 10
    var term = "food"

    // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
    let yelpConsumerKey = "sAwNps3nGeOkNrB2By_dvg"
    let yelpConsumerSecret = "onzreryAqeJsRSWdQNg8yeiZ8v8"
    let yelpToken = "lD_ATQydTA9D0jXsUXf81WObL0QHSw_B"
    let yelpTokenSecret = "cyiJqOz490lVha2ncnOdlMXTmoI"
    
    //
    var results: NSArray = []
    
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
        self.tableView.estimatedRowHeight = 100.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.updateSearchView()
    }
    
    func updateSearchOptions() {
        self.category_filter = SEARCH_OPTIONS.category_filter
        self.radius_filter = SEARCH_OPTIONS.radius_filter
        self.sort = SEARCH_OPTIONS.sort
        self.deals_filter = SEARCH_OPTIONS.deals_filter
        self.limit = SEARCH_OPTIONS.limit
        self.term = SEARCH_OPTIONS.term
        println(SEARCH_OPTIONS.sort)
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        self.updateSearchView()
    }
    
    func updateSearchView() {
        self.searchView.frame.size.width = self.view.frame.size.width
        self.searchBar.layer.cornerRadius = 5
        self.searchBar.clipsToBounds = true
    }
    
    func initActivityIndicator() {
        self.activityIndicator.startAnimating()
        self.activityIndicator.hidesWhenStopped = true
        self.tableView.hidden = true
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
        return self.results.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let business = self.results[indexPath.row] as NSDictionary
        let cell = self.tableView.dequeueReusableCellWithIdentifier("com.cnv.yelp.table.view.cell") as TableViewCell;
        cell.configure(business)
        return cell
    }
    
    
    func updateSearchList() -> Void {
        client.searchWithTerm(term, deals_filter: self.deals_filter, sort: self.sort, radius: self.radius_filter, category_filter: self.category_filter, limit: self.limit, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            if response != nil {
                let dictionary = response! as NSDictionary
                var res = dictionary["businesses"] as NSArray
                if res.count > 0 {
                    self.results = res
                    self.tableView.reloadData()
                }
                self.activityIndicator.stopAnimating()
                self.tableView.hidden = false
                return
            }
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                self.activityIndicator.stopAnimating()
                self.tableView.hidden = false
                return
        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        var height = scrollView.frame.size.height
        var contentYoffset =  scrollView.contentOffset.y
        var distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if (distanceFromBottom < height) {
            self.tableView.hidden = true
            self.activityIndicator.startAnimating()
            self.limit += 10
            self.updateSearchList()
        }
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.term = searchText
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.tableView.hidden = true
        self.activityIndicator.startAnimating()
        self.updateSearchList()
    }
    
    override func viewDidAppear(animated: Bool) {
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.hidden = true
        self.activityIndicator.startAnimating()
        self.updateSearchOptions()
        self.updateSearchList()
    }
}

