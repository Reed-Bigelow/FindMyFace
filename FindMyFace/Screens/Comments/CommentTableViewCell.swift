//
//  CommentTableViewCell.swift
//  FindMyFace
//
//  Created by Developer on 11/28/17.
//  Copyright © 2017 Reed Bigelow. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var profileImageView: CachedImageView!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    private var profile: Profile?
    var comment: Comment?
    
    // MARK: - Public
    func setup(_ comment: Comment) {
        self.comment = comment
        
        self.setupView()
        
        // Load the profile
        if profile == nil {
            RestClientService.request(Profile.self, .user, ["user_id": comment.userId ?? ""], .get) { _, object in
                if let profile = object {
                    self.profileImageView.loadImage(urlString: profile.imageUrl ?? "")
                }
            }
        }
    }
    
    // MARK: - Private
    private func setupView() {
        profileImageView.setRadius(to: profileImageView.frame.height / 2)
        commentLabel.text = comment?.comment
        // usernameLabel.text = profile?.username
        timeLabel.text = comment?.timestamp?.timestamp()
    }
    
    // MARK: - LifeCycle
    override func prepareForReuse() {
        super.prepareForReuse()
        commentLabel.text = ""
        profileImageView.image = nil
    }
}
