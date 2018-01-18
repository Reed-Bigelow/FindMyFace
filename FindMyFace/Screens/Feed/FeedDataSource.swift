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
    private var viewController: FeedItemCellViewDelegate
    
    // MARK: - Public
    func refresh(with posts: [Post]) {
        self.posts = posts
    }
    
    init(_ viewController: FeedItemCellViewDelegate) {
        self.viewController = viewController
    }
    
    // MARK: - Datasource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(FeedItemCellView.self, for: indexPath)
        cell.delegate = viewController
        cell.setup(with: posts![indexPath.row])
        return cell
    }
}
