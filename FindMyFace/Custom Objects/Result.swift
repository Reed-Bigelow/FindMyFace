//
//  Result.swift
//  FindMyFace
//
//  Created by Developer on 11/26/17.
//  Copyright © 2017 Reed Bigelow. All rights reserved.
//

import UIKit
import ObjectMapper

class Result: Mappable {
    
    // MARK: - Properties
    var success: Bool?
    var status: Bool?
    var timestamp: Date?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    convenience init(success: Bool, timestamp: Date, status: Bool) {
        self.init()
        
        self.success = success
        self.timestamp = timestamp
        self.status = status
    }
    
    func mapping(map: Map) {
        success <- map["success"]
        status <- map["status"]
        timestamp <- map["timestamp"]
    }
}
