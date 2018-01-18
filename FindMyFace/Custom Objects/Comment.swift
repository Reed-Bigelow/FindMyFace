//
//  Comment.swift
//  FindMyFace
//
//  Created by Developer on 11/28/17.
//  Copyright © 2017 Reed Bigelow. All rights reserved.
//

import UIKit
import ObjectMapper

class Comment: Mappable {
    
    // MARK: - Properties
    var id: String?
    var userId: String?
    var comment: String?
    var postId: String?
    var timestamp: Date?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    convenience init(id: String, userId: String, postId: String, comment: String, timestamp: Date) {
        self.init()
        
        self.id = id
        self.userId = userId
        self.postId = postId
        self.comment = comment
        self.timestamp = timestamp
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        userId <- map["user_id"]
        postId <- map["post_id"]
        comment <- map["comment"]
        timestamp <- (map["timestamp"], DateTransform())
        
    }
}
