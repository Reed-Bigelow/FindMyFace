//
//  UserDefaults+Helpers.swift
//  FindMyFace
//
//  Created by Developer on 10/31/17.
//  Copyright © 2017 Reed Bigelow. All rights reserved.
//

import UIKit

enum UserDefaultsValues: String {
    case id = "user_id"
    case isLoggedIn = "user_status"
}

extension UserDefaults {
    
    class func setValue(_ value: Any?, forKey key: UserDefaultsValues) {
        UserDefaults.standard.setValue(value, forKey: key.rawValue)
    }
    
    class func value(forKey key: UserDefaultsValues) -> Any? {
        return UserDefaults.standard.object(forKey: key.rawValue)
    }
}
