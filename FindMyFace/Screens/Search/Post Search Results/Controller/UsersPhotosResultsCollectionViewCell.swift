//
//  UsersPhotosResultsCollectionViewCell.swift
//  FindMyFace
//
//  Created by Developer on 12/3/17.
//  Copyright © 2017 Reed Bigelow. All rights reserved.
//

import UIKit

class UsersPhotosResultsCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var imageView: CachedImageView!
    
    // MARK: - Properties
    private var post: Post?
    
    // MARK: - Public
    func setup(with post: Post) {
        self.post = post
        imageView.contentMode = .scaleAspectFill
        
        if let url = post.imageUrl {
            imageView.loadImage(urlString: url)
        }
    }
}
