//
//  PhotoLibraryCollectionDataSource.swift
//  FindMyFace
//
//  Created by Developer on 10/24/17.
//  Copyright © 2017 Reed Bigelow. All rights reserved.
//

import UIKit

class PhotoLibraryCollectionDataSource: NSObject, UICollectionViewDataSource {
    
    // MARK: - Properties
    private var images: [UIImage]?
    
    // MARK: - Public
    func refresh(with images: [UIImage]) {
        self.images = images
    }
    
    // MARK: - Datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(PhotoLibraryCollectionViewCell.self, for: indexPath)
        cell.setup(with: images![indexPath.item])
        return cell
    }
}
