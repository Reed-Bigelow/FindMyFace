//
//  UserSearchCollectionViewCell.swift
//  FindMyFace
//
//  Created by Developer on 11/29/17.
//  Copyright © 2017 Reed Bigelow. All rights reserved.
//

import UIKit

protocol UserSearchCollectionViewCellDelegate: class {
    
    func userDidTapRemove(_ user: Profile)
}

class UserSearchCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    // MARK: - Properties
    private var user: Profile?
    weak var delegate: UserSearchCollectionViewCellDelegate?
    
    // MARK: - Public
    func setup(with user: Profile) {
        self.user = user
        userLabel.text = user.username ?? ""
        setCorner(with: frame.height / 2)
        backgroundImageView.image = UIImage(named: "gradient_\(arc4random_uniform(23) + 1)")
    }
    
    // MARK: - Actions
    @IBAction func removeButton(_ sender: Any) {
        guard let user = user else {
            return
        }
        
        delegate?.userDidTapRemove(user)
    }
}
