//
//  UserSearchTableViewCell.swift
//  FindMyFace
//
//  Created by Developer on 11/29/17.
//  Copyright © 2017 Reed Bigelow. All rights reserved.
//

import UIKit

class UserSearchTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var profileImageView: CachedImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var selectedImageView: UIImageView!
    
    // MARK: - Properties
    var user: Profile?
    
    // MARK: - Public
    func setup(with user: Profile) {
        self.user = user
        profileImageView.loadImage(urlString: user.imageUrl ?? "")
        usernameLabel.text = user.username ?? ""
        profileImageView.setRadius(to: profileImageView.frame.height / 2)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
