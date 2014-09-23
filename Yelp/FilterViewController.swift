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

    @IBOutlet weak var distViewClose: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateYelpCategoryList()
        self.initSections()

        // Do any additional setup after loading the view.
    }
    
    func initSections() {
        self.dealFilter.name = "Offering a Deal"
        
        self.distanceFilter.name = "Distance"
        self.distanceFilter.choices = ["auto", "1 block", "2 blocks"]
        self.distanceFilter.display_choices = ["auto"]
        
        self.sortFilter.name = "Sort By"
        self.sortFilter.choices = ["Best Matched", "Heighest Rated", "Distance"]
        self.sortFilter.display_choices = ["Best Matched"]
        
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
            return self.categories_list.count
        default:
            return 0
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch self.section_keys[indexPath.section] {
        case "deal":
            return self.tableView.dequeueReusableCellWithIdentifier("deal.cell") as DealTableViewCell;
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
            let cell = self.tableView.dequeueReusableCellWithIdentifier("category.cell") as CategoryTableViewCell;
            var cat = self.categories_list[indexPath.row] as NSDictionary
            var title  = cat["title"]
            cell.itemLabel.text = "\(title!)"
            return cell
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
            return
        case "sort":
            self.toggleView(tableView, indexPath: indexPath)
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
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var view = self.view as UITableView
        var categoryViewController: CategoryTableViewController = segue.destinationViewController as CategoryTableViewController
        var index = view.indexPathForSelectedRow()?.row
        var category = self.categories_list[index!]
        categoryViewController.categories_list = category["category"] as NSArray
    }

}
