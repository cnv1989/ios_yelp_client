//
//  FilterViewController.swift
//  Yelp
//
//  Created by Nag Varun Chunduru on 9/22/14.
//  Copyright (c) 2014 Timothy Lee. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var deal: UISwitch!
    @IBOutlet weak var distanceSlider: UISlider!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var sortSelect: UISegmentedControl!
    @IBOutlet weak var showMore: UIButton!
    @IBOutlet weak var selectedDistanceView: UIView!
    @IBOutlet weak var selectionTableView: UITableView!
    @IBOutlet weak var distanceContainerView: UIView!
    @IBOutlet weak var sortLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSelectedDistanceTapped(sender: AnyObject) {
        self.selectedDistanceView.hidden = true
        self.distanceContainerView.hidden = false
        self.distanceContainerView.frame.size.height = 350
        self.updateViewConstraints()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
