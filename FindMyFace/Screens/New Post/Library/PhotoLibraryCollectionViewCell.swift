//
//  PhotoLibraryCollectionViewCell.swift
//  FindMyFace
//
//  Created by Developer on 10/24/17.
//  Copyright © 2017 Reed Bigelow. All rights reserved.
//

import UIKit

class PhotoLibraryCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - Properties
    let blurView = UIView()
    
    override var isSelected: Bool {
        didSet {
            toggleSelectedView(to: isSelected)
        }
    }
    
    // MARK: - Public
    func setup(with image: UIImage) {
        imageView.contentMode = .scaleAspectFill
        
        imageView.image = image
        
        // Set the blur view up
        blurView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        blurView.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        toggleSelectedView(to: false)
        addSubview(blurView)
    }
    
    // MARK: - Private
    private func toggleSelectedView(to bool: Bool) {
        blurView.isHidden = !bool
    }
}
