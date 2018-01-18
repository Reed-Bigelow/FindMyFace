//
//  UsersPhotosResultsViewControllerDataSource.swift
//  FindMyFace
//
//  Created by Developer on 12/3/17.
//  Copyright © 2017 Reed Bigelow. All rights reserved.
//

import UIKit

class UsersPhotosResultsViewControllerDataSource: NSObject, UICollectionViewDataSource {
    
    // MARK: - Properties
    private var posts: [Post]?
    private var users: [Profile]?
    private var usersPhotosResultsViewController: UsersPhotosResultsViewController
    
    // MARK: - Lifecycle
    init(_ usersPhotosResultsViewController: UsersPhotosResultsViewController) {
        self.usersPhotosResultsViewController = usersPhotosResultsViewController
    }
    
    // MARK: - Public
    func refresh(with posts: [Post], _ users: [Profile]) {
        self.posts = posts
        self.users = users
    }
    
    // MARk: - UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(UsersPhotosResultsCollectionViewCell.self, for: indexPath)
        
        if let post = posts?[indexPath.row] {
            cell.setup(with: post)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let users = users else {
            return UICollectionReusableView()
        }
        
        if kind == UICollectionElementKindSectionHeader, let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "UsersResultsCollectionReusableView", for: indexPath) as? UsersResultsCollectionReusableView, let post = posts?.first {
            
            let usernames = users.map { $0.username ?? "" }
            view.setup(with: usernames, post)
            return view
        } else {
            return UICollectionReusableView()
        }
    }
}
