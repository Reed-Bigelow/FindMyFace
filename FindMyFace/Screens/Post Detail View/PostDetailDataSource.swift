//
//  PostDetailDataSource.swift
//  FindMyFace
//
//  Created by Developer on 11/1/17.
//  Copyright © 2017 Reed Bigelow. All rights reserved.
//

import UIKit

class PostDetailDataSource: NSObject, UICollectionViewDataSource {
    
    // MARK: - Properties
    private var post: Post?
    private var viewController: FeedItemCellViewDelegate
    
    // MARK: - Lifecycle
    init(_ viewController: FeedItemCellViewDelegate) {
        self.viewController = viewController
    }
    
    // MARK: - Public
    func refresh(with post: Post) {
        self.post = post
    }
    
    // MARK: - UICollectionDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return post == nil ? 0 : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(FeedItemCellView.self, for: indexPath)
        cell.delegate = viewController
        cell.setup(with: post!)
        return cell
    }
}
