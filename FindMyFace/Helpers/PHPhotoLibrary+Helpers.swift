//
//  PHPhotoLibrary+Helpers.swift
//  FindMyFace
//
//  Created by Developer on 10/24/17.
//  Copyright © 2017 Reed Bigelow. All rights reserved.
//

import UIKit
import Photos

extension PHPhotoLibrary {
    
    func allImages(completion: @escaping ([UIImage]?) -> Void) {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        var images = [UIImage]()
        
        PHPhotoLibrary.requestAuthorization { status in
            if status == PHAuthorizationStatus.authorized {
                let assets = PHAsset.fetchAssets(with: .image, options: fetchOptions)

                assets.enumerateObjects({ asset, _, _ in
                    images.append(asset.image(at: 100))
                })
                
                completion(images)
            }
        }
    }
    
    func image(at item: Int) -> UIImage {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let assets = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        // swiftlint:disable empty_count
        if assets.count > 0 {
            return assets[item].image(at: 414)
        } else {
            return UIImage()
        }
    }
}
