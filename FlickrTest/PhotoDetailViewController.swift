//
//  PhotoDetailViewController.swift
//  FlickrTest
//
//  Created by Anirudha Tolambia on 11/01/17.
//  Copyright © 2017 Anirudha Tolambia. All rights reserved.
//

import UIKit

class PhotoDetailViewController: UIViewController {
    
    fileprivate var imageView: UIImageView!
    fileprivate var detailTextView: UITextView!
    
    fileprivate var imageUrl: String!
    fileprivate var htmlString: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = SharedConstants.sharedInstance.themeColor

        imageView = UIImageView(frame: CGRect(x: 10, y: 50, width: view.bounds.width-20, height: view.bounds.height-150))
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        
        
        detailTextView = UITextView(frame: CGRect(x: 0, y: imageView.frame.maxY, width: view.bounds.height, height: 100))
        detailTextView.backgroundColor = UIColor.clear
        detailTextView.isScrollEnabled = false
        detailTextView.isEditable = false
        view.addSubview(detailTextView)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Check for nil values and populate them
        if let htmlString = self.htmlString {
            detailTextView.text = plainStringFromHtmlString(htmlString)
        }
        
        // Why Pass the UIImage object if we have image in cache
        if let validUrl = imageUrl {
            Utilities.sharedInstance.imageForUrl(validUrl, cache: SharedConstants.sharedInstance.imageCache, completionHandler: { (image, url) in
                if let validImage = image {
                    self.imageView.image = validImage
                }
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setImageUrl(_ imageUrl: String, andDescription description: String) {
        // Setting the values to populate
        self.imageUrl = imageUrl
        self.htmlString = description
    }
    
    fileprivate func plainStringFromHtmlString(_ htmlString: String) -> String {
        // Converting Html string to plain string
        
        do {
            let attrString = try NSMutableAttributedString(data: htmlString.data(using: String.Encoding.utf8)!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
            
            return attrString.string
        }
        catch let error as NSError {
            print("error in converting to attributed string: \(error.localizedDescription)")
            return ""
        }
    }

}
