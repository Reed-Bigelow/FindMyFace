//
//  UILabel+Extensions.swift
//  FindMyFace
//
//  Created by Developer on 11/28/17.
//  Copyright © 2017 Reed Bigelow. All rights reserved.
//

import UIKit

extension String {
    
    func estimatedHeight(_ width: CGFloat, _ size: CGFloat) -> CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: 1000))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = UIFont(name: Constants.fonts.fontName, size: size)
        label.text = self
        label.sizeToFit()
        return label.frame.height
    }
}
