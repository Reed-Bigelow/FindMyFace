//
//  UserSearchCollectionDataSource.swift
//  FindMyFace
//
//  Created by Developer on 11/29/17.
//  Copyright © 2017 Reed Bigelow. All rights reserved.
//

import UIKit

class UserSearchCollectionDataSource: NSObject, UICollectionViewDataSource {
    
    // MARK: - Properties
    private var users: [Profile]?
    private var searchViewController: SearchViewController
    
    init(_ searchViewController: SearchViewController) {
        self.searchViewController = searchViewController
    }
    
    // MARK: - Public
    func refresh(with users: [Profile]) {
        self.users = users
    }
    
    // MARK: - UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(UserSearchCollectionViewCell.self, for: indexPath)
        cell.delegate = searchViewController
        
        if let user = users?[indexPath.row] {
            cell.setup(with: user)
        }
        
        return cell
    }
}
