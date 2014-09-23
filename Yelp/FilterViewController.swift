//
//  FilterViewController.swift
//  Yelp
//
//  Created by Nag Varun Chunduru on 9/22/14.
//  Copyright (c) 2014 Timothy Lee. All rights reserved.
//

import UIKit

class ListFilter {
    var name: NSString = ""
    var choices: NSArray = []
    var display_choices: NSArray = []
    var state = false
    
    func showAll() {
        self.display_choices = self.choices
    }
    
    func show(index: Int) {
        self.display_choices = [self.choices[index]]
    }
}

class BoolFilter {
    var name: NSString = ""
    var state = false
}


class FilterViewController: UITableViewController {
    
    var categories_list = []

    var sections = Dictionary<String, AnyObject>()
    var section_keys = ["deal", "distance", "sort", "category"]
    var distanceFilter = ListFilter()
    var sortFilter = ListFilter()
    var dealFilter = BoolFilter()
    var initial_count: Int = 3

    @IBOutlet weak var distViewClose: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateYelpCategoryList()
        self.initSections()
        self.initial_count = 0

        // Do any additional setup after loading the view.
    }
    
    func initSections() {
        self.dealFilter.name = "Offering a Deal"
        self.dealFilter.state = SEARCH_OPTIONS.deals_filter
        
        self.distanceFilter.name = "Distance"
        self.distanceFilter.choices = ["auto", "1 block", "2 blocks"]
        self.distanceFilter.display_choices = [self.distanceFilter.choices[SEARCH_OPTIONS.radius_filter]]
        
        self.sortFilter.name = "Sort By"
        self.sortFilter.choices = ["Best Matched", "Heighest Rated", "Distance"]
        self.sortFilter.display_choices = [self.sortFilter.choices[SEARCH_OPTIONS.radius_filter]]
        
        sections.updateValue(self.dealFilter, forKey: "deal")
        sections.updateValue(self.distanceFilter, forKey: "distance")
        sections.updateValue(self.sortFilter, forKey: "sort")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return section_keys.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var key = self.section_keys[section] as String

        switch self.section_keys[section] {
        case "deal":
            var sec = self.sections[key]! as BoolFilter
            return "\(sec.name)"
        case "distance":
            var sec = self.sections[key]! as ListFilter
            return "\(sec.name)"
        case "sort":
            var sec = self.sections[key]! as ListFilter
            return "\(sec.name)"
        case "category":
            return "Categories"
        default:
            return "None"
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = 1
        switch self.section_keys[section] {
        case "deal":
            return 1
        case "distance":
            return self.distanceFilter.display_choices.count
        case "sort":
            return self.sortFilter.display_choices.count
        case "category":
            return self.initial_count + 1
        default:
            return 0
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch self.section_keys[indexPath.section] {
        case "deal":
            let cell = self.tableView.dequeueReusableCellWithIdentifier("deal.cell") as DealTableViewCell
            cell.dealStatus.on = SEARCH_OPTIONS.deals_filter
            return cell;
        case "distance":
            let cell = self.tableView.dequeueReusableCellWithIdentifier("selection.cell") as SelectionTableViewCell;
            var choice: AnyObject = self.distanceFilter.display_choices[indexPath.row]
            cell.itemLabel.text = "\(choice)"
            return cell
        case "sort":
            let cell = self.tableView.dequeueReusableCellWithIdentifier("selection.cell") as SelectionTableViewCell;
            var choice: AnyObject = self.sortFilter.display_choices[indexPath.row]
            cell.itemLabel.text = "\(choice)"
            return cell
        case "category":
            if indexPath.row < self.initial_count {
                let cell = self.tableView.dequeueReusableCellWithIdentifier("category.cell") as CategoryTableViewCell;
                var cat = self.categories_list[indexPath.row] as NSDictionary
                var title  = cat["title"]
                var alias = cat["alias"]
                cell.itemLabel.text = "\(title!)"
                cell.categorySwitch.restorationIdentifier = "\(alias!)"
                return cell
            } else {
                return self.tableView.dequeueReusableCellWithIdentifier("showmore.cell") as CategoryTableViewCell;
            }
        default:
            return self.tableView.dequeueReusableCellWithIdentifier("selection.cell") as SelectionTableViewCell;
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch self.section_keys[indexPath.section] {
        case "deal":
            return
        case "distance":
            self.toggleView(tableView, indexPath: indexPath)
            SEARCH_OPTIONS.radius_filter = indexPath.row
            return
        case "sort":
            self.toggleView(tableView, indexPath: indexPath)
            SEARCH_OPTIONS.sort = indexPath.row
            return
        default:
            return
        }
    }
    
    func toggleView(tableView: UITableView, indexPath: NSIndexPath) {
        var key = self.section_keys[indexPath.section]
        var listFilter = self.sections[key]! as ListFilter
        var state = listFilter.state
        if state == false {
            listFilter.state = true
            listFilter.showAll()
        } else {
            listFilter.state = false
            listFilter.show(indexPath.row)
        }
        var view = self.view as UITableView
        view.reloadData()
    }
    
    func updateYelpCategoryList() -> Void {
        
        let request = NSMutableURLRequest(URL: NSURL.URLWithString("https://dl.dropboxusercontent.com/u/42075244/category.json"))
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{ (response, data, error) in
            var errorValue: NSError? = nil
            if data == nil {
                if self.hasConnectivity() == false {
                } else {
                }
                return
            }
            let parsedResult: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &errorValue)
            if error != nil {
                println("\(error.description)")
            }
            
            if parsedResult != nil {
                self.categories_list = parsedResult! as NSArray
                var view = self.view as UITableView
                self.initial_count = min(self.categories_list.count, 3)
                view.reloadData()
            }
        })
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
    
    @IBOutlet var onShowMore: UITapGestureRecognizer!
    
    @IBAction func onShowMoreTapped(sender: AnyObject) {
        println("tapped")
        var view = self.view as UITableView
        self.initial_count = max(self.categories_list.count - 1, 0)
        view.reloadData()
    }

    @IBAction func onSearchClicked(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var view = self.view as UITableView
        var categoryViewController: CategoryTableViewController = segue.destinationViewController as CategoryTableViewController
        var index = view.indexPathForSelectedRow()?.row
        var category = self.categories_list[index!]
        categoryViewController.categories_list = category["category"] as NSArray
    }

    @IBAction func dealSwitchValueChanged(sender: AnyObject) {
        var dealSwitch = sender as UISwitch
        SEARCH_OPTIONS.deals_filter = dealSwitch.on
    }
}
