//
//  CollectionViewCell.swift
//  FindMyFace
//
//  Created by Developer on 10/23/17.
//  Copyright © 2017 Reed Bigelow. All rights reserved.
//

import UIKit
import ObjectMapper

protocol FeedItemCellViewDelegate: class {
    
    func didSelectViewComments(for post: Post)
    func didTapProfile(_ userId: String)
}

class FeedItemCellView: UICollectionViewCell {
    
    enum ButtonType {
        case bookmark
        case like
    }
    
    // MARK: - Properties
    private var post: Post?
    weak var delegate: FeedItemCellViewDelegate?
    
    // MARK: - Outlets
    // Image
    @IBOutlet weak var profileImage: CachedImageView!
    @IBOutlet weak var postImage: CachedImageView!
    
    // Buttons
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var viewCommentsButton: UIButton!
    
    // Labels
    @IBOutlet weak var profileUsername: UILabel!
    @IBOutlet weak var likedBylabel: UILabel!
    @IBOutlet weak var postDateLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        removeAllSubviews()
    }
    
    // MARK: - Public
    func setup(with post: Post) {
        
        // Set the post
        self.post = post
        
        // Set the image radius for profile image
        profileImage.setRadius(to: profileImage.frame.height / 2)
        
        // Set the aspect type
        postImage.contentMode = .scaleAspectFill
        
        // Set the posters name
        profileUsername.text = post.username
        
        profileUsername.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapProfile)))
        
        profileUsername.isUserInteractionEnabled = true
        
        // Set the date time stamp
        postDateLabel.text = post.timestamp?.timestamp()
        
        // Update bookmark status and like
        checkUserPostStatus()
        
        getLikers()
        
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
    @objc private func didTapProfile() {
        delegate?.didTapProfile(post?.userId ?? "")
    }
    
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
    
    private func checkUserPostStatus() {
        
        RestClientService.request(.postUserBookmarkStatus, ["user_id": UserDefaults.value(forKey: .id) as! String, "post_id": post?.id ?? ""], nil, .get) { _, rawJson in
            if let status = rawJson?["status"] as? Bool {
                DispatchQueue.main.async {
                    self.bookmarkButton.isSelected = status
                }
            }
        }
        
        RestClientService.request(.postUserLikeStatus, ["user_id": UserDefaults.value(forKey: .id) as! String, "post_id": post?.id ?? ""], nil, .get) { _, rawJson in
            if let status = rawJson?["status"] as? Bool {
                DispatchQueue.main.async {
                    self.likeButton.isSelected = status
                }
            }
        }
    }
    
    private func updateUserStatus(to bool: Bool, for buttonType: ButtonType) {
        
        let parameters = ["user_id": UserDefaults.value(forKey: .id) as! String,
                          "post_id": post?.id ?? "",
                          "status": bool] as [String: Any]
    
        switch buttonType {
        case .bookmark:
            RestClientService.request(.userBookmarks, nil, parameters, .post) { _, _  in
                
            }
        case .like:
            RestClientService.request(.userLikes, nil, parameters, .post) { _, _  in
                self.getLikers()
            }
        }
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
        
        let userTagImageView = UIImageView(frame: CGRect(x: Int(x) - 40, y: Int(y), width: 100, height: 50))
        userTagImageView.image = #imageLiteral(resourceName: "User-Tag")
        
        let label = UILabel(frame: CGRect(x: 5, y: 20, width: 95, height: 30))
        label.text = faceLocation.username
        label.textAlignment = .center
        label.textColor = .white
        label.font = Constants.fonts.size12
        userTagImageView.addSubview(label)
        
        return userTagImageView
    }
    
    private func getLikers() {
        RestClientService.request(.postLikers, ["post_id": post?.id ?? ""], nil, .get) { _, response in
            if let likers = response?["likers"] as? [String] {
                self.createLikersString(with: likers, completion: { text in
                    DispatchQueue.main.async {
                        if text.isEmpty {
                            self.likedBylabel.isHidden = true
                        } else {
                            self.likedBylabel.isHidden = false
                            self.likedBylabel.text = text
                        }
                    }
                })
            }
        }
    }
    
    private func createLikersString(with likers: [String], completion: @escaping (String) -> Void) {
        var baseLikeText = "Liked by "
        
        if likers.isEmpty {
            completion("")
        } else if likers.count <= 2 {
            for (index, liker) in likers.enumerated() {
                getProfile(for: liker, completion: { profile in
                    baseLikeText += index == 0 ? profile?.username ?? "" : ", \(profile?.username ?? "")"
                    if index == likers.count - 1 {
                        completion(baseLikeText)
                    }
                })
            }
        } else {
            for index in 0...1 {
                getProfile(for: likers[index], completion: { profile in
                    baseLikeText += index == 0 ? profile?.username ?? "" : ", \(profile?.username ?? "")"
                    
                    if index == 1 {
                        baseLikeText += " and \(likers.count - 2) others"
                        completion(baseLikeText)
                    }
                })
            }
        }
    }
    
    private func getProfile(for userId: String, completion: @escaping (Profile?) -> Void) {
        RestClientService.request(.user, ["user_id": userId], nil, .get) { _, rawJson in
            if let json = rawJson?["user_info"] as? [String: Any] {
                let profile = Mapper<Profile>().map(JSON: json)
                completion(profile)
            }
        }
    }
    
    // MARK: - Actions
    @IBAction func likeButton(_ sender: Any) {
        likeButton.isSelected = !likeButton.isSelected
        updateUserStatus(to: likeButton.isSelected, for: .like)
    }
    
    @IBAction func commentButton(_ sender: Any) {
        guard let post = post else {
            return
        }
        
        delegate?.didSelectViewComments(for: post)
    }

    @IBAction func messageButton(_ sender: Any) {
         // TODO: - Implement messaging
    }
    
    @IBAction func bookmarkButton(_ sender: Any) {
        bookmarkButton.isSelected = !bookmarkButton.isSelected
        updateUserStatus(to: bookmarkButton.isSelected, for: .bookmark)
    }
}
