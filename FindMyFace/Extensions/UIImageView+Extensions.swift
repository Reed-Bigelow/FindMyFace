//
//  UIImageView+Extensions.swift
//  FindMyFace
//
//  Created by Developer on 10/23/17.
//  Copyright © 2017 Reed Bigelow. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func setRadius(to float: CGFloat) {
        layer.cornerRadius = float
        layer.masksToBounds = true
    }
}
