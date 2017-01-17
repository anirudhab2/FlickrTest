//
//  HttpCalls.swift
//  FlickrTest
//
//  Created by Anirudha Tolambia on 11/01/17.
//  Copyright © 2017 Anirudha Tolambia. All rights reserved.
//

import UIKit

class HttpCalls: NSObject {
    


    func getResultsForPhotos(_ completion: @escaping (_ statusCode: Int, _ photoList: [PhotoObject]) -> ()) {
        
        let url = "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1"
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        let task = session.dataTask(with: request) {(data, response, error) -> () in
            
            if (error != nil) {
                print("Error in getting photos: \(error)")
                completion(-1, [])
                
            } else {
                
                guard let validData = data,
                    let httpResponse = response as? HTTPURLResponse else {
                        completion(-1, [])
                        return
                }
                
                completion(httpResponse.statusCode, self.parsePhotoListFromData(validData))
            }
        }
        
        task.resume()
    }
    
    fileprivate func parsePhotoListFromData(_ data: Data) -> [PhotoObject] {
        // Gets the response data, parses it, then returns array of PhotoObject
        
//        let jsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)!
//        print(jsonString)
        
        var photoList: [PhotoObject] = []
        
        do {
            guard let responseDict = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary,
                let itemsDict = responseDict[SharedConstants.sharedInstance.jsonKeys.itemsKey] as? [NSDictionary] else {
                return []
            }
            
            for item in itemsDict {
                
                var mediaUrl: String?
                var description: String?
                
                description = item[SharedConstants.sharedInstance.jsonKeys.descriptionKey] as? String
                
                if let media = item[SharedConstants.sharedInstance.jsonKeys.mediaKey] as? NSDictionary {
                    mediaUrl = media[SharedConstants.sharedInstance.jsonKeys.mediaUrlKey] as? String
                }
                
                if (mediaUrl != nil && description != nil) {
                    let newObject = PhotoObject(mediaUrl: mediaUrl!, descriptionString: description!)
                    photoList.append(newObject)
                }
            }
            
            return photoList
            
        } catch let error as NSError {
            print("Unable to parse json: \(error)")
            return photoList
        }
    }
}
