//
//  FaceLocation.swift
//  FindMyFace
//
//  Created by Developer on 10/24/17.
//  Copyright © 2017 Reed Bigelow. All rights reserved.
//

import UIKit
import ObjectMapper

class FaceLocation: Mappable {

    // MARK: - Properties
    var userId: String?
    var username: String?
    var x1: Int?
    var x2: Int?
    var y1: Int?
    var y2: Int?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    convenience init(userId: String,
                     username: String,
                     x1: Int,
                     x2: Int,
                     y1: Int,
                     y2: Int) {
        self.init()
        
        self.userId = userId
        self.username = username
        self.x1 = x1
        self.x2 = x2
        self.y1 = y1
        self.y2 = y2
    }
    
    func mapping(map: Map) {
        userId <- map["user_id"]
        username <- map["username"]
        x1 <- map["x_1"]
        x2 <- map["x_2"]
        y1 <- map["y_1"]
        y2 <- map["y_2"]
    }
}
