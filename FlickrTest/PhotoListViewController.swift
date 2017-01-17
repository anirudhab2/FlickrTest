//
//  PhotoListViewController.swift
//  FlickrTest
//
//  Created by Anirudha Tolambia on 11/01/17.
//  Copyright © 2017 Anirudha Tolambia. All rights reserved.
//

import UIKit

// MARK: - Main Class
class PhotoListViewController: UIViewController {
    
    fileprivate var collectionView: UICollectionView!
    fileprivate var activityIndicator: UIActivityIndicatorView!
    fileprivate var photoList: [PhotoObject] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = SharedConstants.sharedInstance.themeColor
        
        let refreshButton = UIBarButtonItem(title: "Refresh", style: .plain, target: self, action: #selector(self.populateResults))
        self.navigationItem.rightBarButtonItem = refreshButton
        
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator.frame = view.bounds
        activityIndicator.backgroundColor = UIColor.red
        activityIndicator.center = view.center
        
        
        let itemWidth = view.bounds.width/2 - 30

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        flowLayout.minimumLineSpacing = 10.0
        flowLayout.minimumInteritemSpacing = 10.0
        
        
        let rect = view.bounds.insetBy(dx: 20, dy: 0)
        collectionView = UICollectionView(frame: rect, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.allowsMultipleSelection = false
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        
        view.addSubview(collectionView)
        
        populateResults()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Getting Results From Server
    func populateResults() {
        
        
        
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        let calls = HttpCalls()
        calls.getResultsForPhotos { (statusCode, photoList) in
            
            
            DispatchQueue.main.async(execute: {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.removeFromSuperview()
            })
            
            
            if (statusCode >= 200 && statusCode < 300) {
                DispatchQueue.main.async(execute: {
                    self.photoList = photoList
                    self.collectionView.reloadData()
                    
                    if (!self.photoList.isEmpty) {
                        let indexPath = NSIndexPath(item: 0, section: 0) as IndexPath
                        self.collectionView.scrollToItem(at: indexPath, at: .top, animated: false)
                    }
                })
            } else {
                DispatchQueue.main.async(execute: {
                    self.showRequestFailAlert()
                })
            }
        }
    }
    
    // Showing Alert in case of http error
    fileprivate func showRequestFailAlert() {
        let message = "Error in getting data, please try again"
        
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        
        let retryAction = UIAlertAction(title: "Retry", style: .default) { (action) in
            self.populateResults()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alertController.addAction(retryAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: Collection View DataSource and Delegate
extension PhotoListViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PhotoCollectionViewCell
        
        let photo = photoList[indexPath.row]
        
        Utilities.sharedInstance.imageForUrl(photo.mediaUrl, cache: SharedConstants.sharedInstance.imageCache) { (image, url) in
            if let validImage = image {
                if (url == photo.mediaUrl) {
                    cell.setImage(validImage)
                } else {
                    cell.setImage(UIImage())
                }
            } 
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let photo = photoList[indexPath.row]
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PhotoDetailViewController") as! PhotoDetailViewController
        vc.setImageUrl(photo.mediaUrl, andDescription: photo.descriptionString)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}




