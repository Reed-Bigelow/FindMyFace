//
//  Constants.swift
//  FindMyFace
//
//  Created by Developer on 10/23/17.
//  Copyright © 2017 Reed Bigelow. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    
    struct URLS {
        
        static let hostUrl: URL = {
            guard let urlString = Bundle(for: RestClientService.self).infoDictionary?["HostUrl"] as? String,
                let url = URL(string: urlString) else {
                    fatalError()
            }
            
            return url
        }()
    }
    
    struct ScreenDimensions {
        
        static let BOUNDS = UIScreen.main.bounds
        static let WIDTH = Constants.ScreenDimensions.BOUNDS.width
        static let HEIGHT = Constants.ScreenDimensions.BOUNDS.height
    }
    
    struct fonts {
        
        static let fontName = "Times"
        static let size12 = UIFont(name: Constants.fonts.fontName, size: 12)
    }
    
    struct Colors {
        
        static let profileSubviewButtonSelected = UIColor(red: 61 / 255, green: 154 / 255, blue: 239 / 255, alpha: 1.0)
        static let profileSubviewButtonDeselected = UIColor(red: 152 / 255, green: 153 / 255, blue: 154 / 255, alpha: 1.0)
    }
    
    struct DeviceType {
        
        static let iPhoneX = ScreenDimensions.HEIGHT == 812
    }
}
