//
//  Profile.swift
//  FindMyFace
//
//  Created by Developer on 10/31/17.
//  Copyright © 2017 Reed Bigelow. All rights reserved.
//

import UIKit
import ObjectMapper

class Profile: Mappable {

    // MARK: - Properties
    var id: String?
    var name: String?
    var username: String?
    var imageUrl: String?
    var userLikeCount: Int?
    var userTaggedCount: Int?
    var userPostCount: Int?
    var summary: String?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    convenience init(id: String,
                     name: String,
                     username: String,
                     imageUrl: String,
                     userLikeCount: Int,
                     userTaggedCount: Int,
                     userPostCount: Int,
                     summary: String) {
        self.init()
        
        self.id = id
        self.name = name
        self.username = username
        self.imageUrl = imageUrl
        self.userLikeCount = userLikeCount
        self.userTaggedCount = userTaggedCount
        self.userPostCount = userPostCount
        self.summary = summary
    }
    
    convenience init(with userId: String, completion: @escaping () -> Void) {
        self.init()
        
        RestClientService.request(Profile.self, .user) { _, profile in
            if let profile = profile {
                self.id = profile.id
                self.name = profile.name
                self.username = profile.username
                self.imageUrl = profile.imageUrl
                self.userLikeCount = profile.userLikeCount
                self.userTaggedCount = profile.userTaggedCount
                self.userPostCount = profile.userPostCount
                self.summary = profile.summary
            }
            
            completion()
        }
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        username <- map["username"]
        imageUrl <- map["profile_image_url"]
        userLikeCount <- map["total_likes"]
        userTaggedCount <- map["total_tags"]
        userPostCount <- map["total_posts"]
        summary <- map["summary"]
    }
}
