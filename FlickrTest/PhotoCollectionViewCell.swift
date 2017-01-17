//
//  PhotoCollectionViewCell.swift
//  FlickrTest
//
//  Created by Anirudha Tolambia on 11/01/17.
//  Copyright © 2017 Anirudha Tolambia. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    fileprivate var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    fileprivate func initialize() {
        imageView = UIImageView(frame: self.bounds)
        imageView.contentMode = .scaleAspectFit
        self.addSubview(imageView)
    }
    
    func setImage(_ image: UIImage) {
        imageView.image = image
    }
}
