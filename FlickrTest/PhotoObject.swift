//
//  PhotoObject.swift
//  FlickrTest
//
//  Created by Anirudha Tolambia on 11/01/17.
//  Copyright © 2017 Anirudha Tolambia. All rights reserved.
//

import UIKit

class PhotoObject: NSObject {
    
    init(mediaUrl: String, descriptionString: String) {
        self.mediaUrl = mediaUrl
        self.descriptionString = descriptionString
    }
    
    var mediaUrl: String!
    var descriptionString: String!
}
