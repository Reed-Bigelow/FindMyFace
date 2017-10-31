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
}
