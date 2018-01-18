//
//  UIButton+Extensions.swift
//  FindMyFace
//
//  Created by Developer on 10/31/17.
//  Copyright © 2017 Reed Bigelow. All rights reserved.
//

import UIKit

extension UIButton {
    
    func setBorder(_ width: CGFloat, with color: UIColor) {
        layer.borderColor = color.cgColor
        layer.borderWidth = width
    }
}
