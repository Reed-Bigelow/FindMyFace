//
//  Post.swift
//  FindMyFace
//
//  Created by Developer on 10/23/17.
//  Copyright © 2017 Reed Bigelow. All rights reserved.
//

import UIKit
import ObjectMapper

class Post: Mappable {
    
    // MARK: - Properties
    var id: String?
    var imageUrl: String?
    var userId: String?
    var username: String?
    var profileImageUrl: String?
    var faceLocations: [FaceLocation]?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    convenience init(
        id: String,
        imageUrl: String,
        userId: String,
        username: String,
        profileImageUrl: String,
        faceLocations: [FaceLocation]) {
        
        self.init()
        
        self.id = id
        self.imageUrl = imageUrl
        self.userId = userId
        self.username = username
        self.profileImageUrl = profileImageUrl
        self.faceLocations = faceLocations
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        imageUrl <- map["url"]
        userId <- map["user_id"]
        username <- map["name"]
        profileImageUrl <- map["profile_image_url"]
        faceLocations <- map["face_locations"]
    }
}
