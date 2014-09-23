//
//  TableViewCell.swift
//  Yelp
//
//  Created by Nag Varun Chunduru on 9/21/14.
//  Copyright (c) 2014 Timothy Lee. All rights reserved.
//

import UIKit

var ImageCache =  [String : UIImage]()

class TableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var pic: UIImageView!
    @IBOutlet weak var ratings: UIImageView!
    @IBOutlet weak var restaurant: UILabel!
    @IBOutlet weak var reviews: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var categories: UILabel!
    @IBOutlet weak var phone: UILabel!
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        restaurant.preferredMaxLayoutWidth = frame.width
        self.pic.layer.cornerRadius = 10
        self.pic.clipsToBounds = true
    }

    func configure(result: NSDictionary) {
        var name: AnyObject = (result["name"] != nil) ? result["name"]! : "n/a"
        var phone: AnyObject = (result["phone"] != nil) ? result["phone"]! : "n/a"
        var picUrl: AnyObject = (result["image_url"] != nil) ? result["image_url"]! : "http://placehold.it/350x150"
        var ratingsUrl: AnyObject = (result["rating_img_url"] != nil) ? result["rating_img_url"]! : "http://placehold.it/350x150"
        var location: NSDictionary = result["location"]! as NSDictionary

        var joiner = ", "

        var displayAddress = location["display_address"] as [String]
        var address = joiner.join(displayAddress)
        
        var categories = result["categories"] as NSArray
        var cats: [String] = []
        
        for category in categories {
            cats.append((category as Array)[0] as String)
        }
        
        var reviews: AnyObject = result["review_count"]!
        
        self.categories.text = joiner.join(cats)
        self.restaurant.text = "\(name)"
        self.phone.text = "call: \(phone)"
        self.address.text = address
        self.reviews.text = "reviews: \(reviews)"
        self.loadImage("\(picUrl)", imageView: self.pic)
        self.loadImage("\(ratingsUrl)", imageView: self.ratings)
    }
    
    func loadImage(urlString: NSString, imageView: UIImageView) {
        var image: UIImage? = nil
        let imageRequestSuccess = {
            (request : NSURLRequest!, response : NSHTTPURLResponse!, image : UIImage!) -> Void in
            ImageCache[urlString] = image
            imageView.image = image;
        }
        
        let imageRequestFailure = {
            (request : NSURLRequest!, response : NSHTTPURLResponse!, error : NSError!) -> Void in
            NSLog("imageRequrestFailure")
        }
        
        if image == nil {
            var imgURL: NSURL = NSURL(string: urlString)
            // Download an NSData representation of the image at the URL
            let request: NSURLRequest = NSURLRequest(URL: imgURL)
            imageView.setImageWithURLRequest(request, placeholderImage: nil, success: imageRequestSuccess, failure: imageRequestFailure)
        } else {
            dispatch_async(dispatch_get_main_queue(), {
                imageView.image = image
            })
        }

    }
}
