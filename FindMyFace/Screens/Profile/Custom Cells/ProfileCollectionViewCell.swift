//
//  ProfileCollectionViewCell.swift
//  FindMyFace
//
//  Created by Developer on 10/31/17.
//  Copyright © 2017 Reed Bigelow. All rights reserved.
//

import UIKit

class ProfileCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var imageView: CachedImageView!
    
    // MARK: - Public
    func setup(withProfileItem post: Post) {
        if let url = post.imageUrl {
            imageView.loadImage(urlString: url)
        }
        
        setupView()
    }
    
    // MARK: - Private
    private func setupView() {
        imageView.contentMode = .scaleAspectFill
    }
}
