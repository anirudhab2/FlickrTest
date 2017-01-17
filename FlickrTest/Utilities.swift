//
//  Utilities.swift
//  FlickrTest
//
//  Created by Anirudha Tolambia on 11/01/17.
//  Copyright © 2017 Anirudha Tolambia. All rights reserved.
//

import Foundation
import UIKit

class Utilities {
    
    class var sharedInstance: Utilities {
        struct Static {
            static let instance = Utilities()
        }
        return Static.instance
    }
    
    
    func imageForUrl(_ urlString: String, cache:NSCache<AnyObject, AnyObject>, completionHandler:@escaping (_ image: UIImage?, _ url: String) -> ()) {
        // Check first if the image exists in cache otherwise download it
        
        DispatchQueue.global(qos: .userInitiated).async { 
            let data: Data? = cache.object(forKey: urlString as AnyObject) as? Data
            
            if let goodData = data {
                let image = UIImage(data: goodData)
                DispatchQueue.main.async(execute: {() in
                    completionHandler(image, urlString)
                })
                return
            }
            
            let downloadTask = URLSession.shared.dataTask(with: URL(string: urlString)!) {(data, response, error) -> () in
                if (error != nil) {
                    
                    completionHandler(nil, urlString)
                    return
                }
                
                if data != nil {
                    let image = UIImage(data: data!)
                    cache.setObject(data! as AnyObject, forKey: urlString as AnyObject)
                    DispatchQueue.main.async(execute: {() in
                        completionHandler(image, urlString)
                    })
                    return
                }
                
            }
            downloadTask.resume()
        }
    }
}
