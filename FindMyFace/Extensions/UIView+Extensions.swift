//
//  UIView+Extensions.swift
//  FindMyFace
//
//  Created by Developer on 11/29/17.
//  Copyright © 2017 Reed Bigelow. All rights reserved.
//

import UIKit

extension UIView {
    
    func setCorner(with radius: CGFloat) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
    
    func removeSubviews() {
        subviews.forEach {
            $0.removeFromSuperview()
        }
    }
}
