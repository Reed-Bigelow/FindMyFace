//
//  ProfileCollectionDatasource.swift
//  FindMyFace
//
//  Created by Developer on 10/31/17.
//  Copyright © 2017 Reed Bigelow. All rights reserved.
//

import UIKit

class ProfileCollectionDataSource: NSObject, UICollectionViewDataSource {
    
    // MARK: - Private
    private var profile: Profile?
    private var posts: [Post]?
    var profileSummaryReusableView: ProfileSummaryReusableView?
    private var profileViewController: ProfileViewController
    private var selectedSubview: ProfileSubview = .userPosts
    
    init(_ profileViewController: ProfileViewController) {
        self.profileViewController = profileViewController
    }
    
    // MARK: - Public
    func reload(withProfilePosts profile: Profile, _ posts: [Post], _ selectedSubview: ProfileSubview) {
        self.profile = profile
        self.posts = posts
        self.selectedSubview = selectedSubview
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts?.count ?? 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return profile == nil ? 0 : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(ProfileCollectionViewCell.self, for: indexPath)
        
        if let item = posts?[indexPath.item] {
            cell.setup(withProfileItem: item)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let profile = profile else {
            return UICollectionReusableView()
        }
        
        if kind == UICollectionElementKindSectionHeader {
            profileSummaryReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ProfileSummaryReusableView", for: indexPath) as? ProfileSummaryReusableView
            profileSummaryReusableView?.delegate = profileViewController
            profileSummaryReusableView?.setup(with: profile, selectedSubview: selectedSubview)
            return profileSummaryReusableView!
        } else {
            return UICollectionReusableView()
        }
    }
}
