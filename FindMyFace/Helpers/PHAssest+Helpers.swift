//
//  PHAssest+Helpers.swift
//  FindMyFace
//
//  Created by Developer on 10/24/17.
//  Copyright © 2017 Reed Bigelow. All rights reserved.
//

import Photos

extension PHAsset {
    
    func image(at size: Int) -> UIImage {
        let manager = PHImageManager.default()
        let thumbnailSize = CGSize(width: size, height: size)
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.version = .original
        
        var image = UIImage()

        manager.requestImage(for: self, targetSize: thumbnailSize, contentMode: .aspectFill, options: requestOptions) { returnedImage, _ in
            guard let returnedImage = returnedImage else {
                return
            }
            
            image = returnedImage
        }
        
        return image
    }
}
