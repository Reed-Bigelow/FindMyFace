//
//  CollectionViewCell.swift
//  FindMyFace
//
//  Created by Developer on 10/23/17.
//  Copyright © 2017 Reed Bigelow. All rights reserved.
//

import UIKit

class FeedItemCell: UICollectionViewCell {
    
    // MARK: - Properties
    @IBOutlet weak var profileImage: CachedImageView!
    @IBOutlet weak var profileUsername: UILabel!
    @IBOutlet weak var postImage: CachedImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        removeAllSubviews()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 10
        layer.masksToBounds = true
    }
    
    // MARK: - Public
    func setup(with post: Post) {
        
        // Set the image radius for profile image
        profileImage.setRadius(to: profileImage.frame.height / 2)
        
        // Set the aspect type
        postImage.contentMode = .scaleAspectFill
        
        // Set the posters name
        profileUsername.text = post.username
        
        // Make sure the image url isnt blank
        guard let profileImageUrl = post.profileImageUrl, let imageUrl = post.imageUrl else {
            return
        }
        
        // Load the images
        profileImage.loadImage(urlString: profileImageUrl)
        
        // Load the post image and when done add tags
        postImage.loadImage(urlString: imageUrl) {
            // Check if there are any faces
            guard let faceLocations = post.faceLocations else {
                return
            }
            
            // Run through all the faces
            for faceLocation in faceLocations {
                // Username tag
                guard let tag = self.usernameTag(for: faceLocation) else {
                    return
                }
                
                // Add subviews
                self.postImage.addSubview(tag)
                self.postImage.bringSubview(toFront: tag)
            }
        }
        
        // Add gester recognizer
        let gester = UITapGestureRecognizer(target: self, action: #selector(self.toggleSubviews))
        self.postImage.isUserInteractionEnabled = true
        self.postImage.addGestureRecognizer(gester)
    }
    
    // MARK: - Private
    private func removeAllSubviews() {
        postImage.subviews.forEach {
            $0.removeFromSuperview()
        }
    }
    
    @objc private func toggleSubviews() {
        postImage.subviews.forEach {
            $0.isHidden = !$0.isHidden
        }
    }
    
    @objc private func moveToUserProfile() {
        print("Moving")
    }
    
    private func usernameTag(for faceLocation: FaceLocation) -> UIView? {
        // Make sure eveything is there
        guard let right = faceLocation.x2,
            let left = faceLocation.y2,
            let bottom = faceLocation.y1,
            let top = faceLocation.x1,
            let imageWidth = self.postImage.image?.size.width,
            let imageHeight = self.postImage.image?.size.height else {
            return nil
        }
        
        // Add mod for the image pixels to the points
        let xMod = imageWidth / self.postImage.frame.width
        let yMod = imageHeight / self.postImage.frame.height
        
        // Create the x and y cords
        let x = Double(((right - left) / 2) + left) / Double(xMod)
        let y = Double((bottom - top) + top) / Double(yMod)
        
        let userTagImageView = UIImageView(frame: CGRect(x: Int(x) - 50, y: Int(y), width: 100, height: 50))
        userTagImageView.image = #imageLiteral(resourceName: "User-Tag")
        
        let label = UILabel(frame: CGRect(x: 5, y: 20, width: 95, height: 30))
        label.text = faceLocation.username
        label.textAlignment = .center
        label.textColor = .white
        label.font = Constants.fonts.size12
        userTagImageView.addSubview(label)
        
        return userTagImageView
    }
}
