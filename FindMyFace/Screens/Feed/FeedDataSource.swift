//
//  FeedDataSource.swift
//  FindMyFace
//
//  Created by Developer on 10/23/17.
//  Copyright © 2017 Reed Bigelow. All rights reserved.
//

import UIKit

class FeedDataSource: NSObject, UICollectionViewDataSource {
    
    // MARK: - Properties
    private var posts: [Post]?
    
    // MARK: - Public
    func refresh(with posts: [Post]) {
        self.posts = posts
    }
    
    // MARK: - Datasource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(FeedItemCell.self, for: indexPath)
        cell.setup(with: posts![indexPath.row])
        return cell
    }
}
