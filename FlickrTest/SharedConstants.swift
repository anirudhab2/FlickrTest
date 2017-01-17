//
//  SharedConstants.swift
//  FlickrTest
//
//  Created by Anirudha Tolambia on 11/01/17.
//  Copyright © 2017 Anirudha Tolambia. All rights reserved.
//

import UIKit

class SharedConstants {
    
    class var sharedInstance: SharedConstants {
        struct Static {
            static let instance = SharedConstants()
        }
        return Static.instance
    }
    
    let imageCache = NSCache<AnyObject, AnyObject>()
    
    let jsonKeys = JsonKeys()
    
    let themeColor = UIColor(red: 247/255, green: 233/250, blue: 185/250, alpha: 1)
}

struct JsonKeys {
    let itemsKey = "items"
    let descriptionKey = "description"
    let mediaKey = "media"
    let mediaUrlKey = "m"
}
