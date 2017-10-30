//
//  Feed.swift
//  FindMyFace
//
//  Created by Developer on 10/23/17.
//  Copyright © 2017 Reed Bigelow. All rights reserved.
//

import UIKit
import ObjectMapper

class Feed: Mappable  {
    
    // MARK: - Properties
    var posts: [Post]?
    var currentPostDate: String?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    convenience init(posts: [Post]) {
        self.init()
        
        self.posts = posts
    }
    
    func mapping(map: Map) {
        posts <- map["posts"]
    }
}
