//
//  UsersResultsCollectionReusableView.swift
//  FindMyFace
//
//  Created by Developer on 12/3/17.
//  Copyright © 2017 Reed Bigelow. All rights reserved.
//

import UIKit

class UsersResultsCollectionReusableView: UICollectionReusableView {
    
    // MARK: - Properties
    private var post: Post?
    private var usernames: [String]?
    
    // MARK: - Outlets
    @IBOutlet weak var imageView: CachedImageView!
    @IBOutlet weak var usersLabel: UILabel!
    
    // MARK: - public
    func setup(with usernames: [String], _ post: Post) {
        
        self.post = post
        self.usernames = usernames
        
        var tempNameString = ""
        
        usernames.forEach {
            if !tempNameString.isEmpty {
               tempNameString.append(", ")
            }
            
            tempNameString.append($0)
        }
        
        usersLabel.text = tempNameString
        
        if let url = post.imageUrl {
            imageView.loadImage(urlString: url, completion: {
                self.imageView.removeSubviews()
                self.imageView.addBlur(0.4)
            })
        }
    }
}
