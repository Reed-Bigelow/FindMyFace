//
//  RestClientService.swift
//  FindMyFace
//
//  Created by Developer on 10/23/17.
//  Copyright © 2017 Reed Bigelow. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

class RestClientService: NSObject {
    
    enum RequestEndpoint: String {
        case feed = "feed"
        case user = "user"
        case upload = "upload"
        case userPosts = "user/posts"
        case userTaggedPosts = "user/tagged"
        case userBookmarks = "user/bookmarks"
        case postUserBookmarkStatus = "post/bookmark"
        case postUserLikeStatus = "post/user/like"
        case postLikers = "post/likers"
        case userLikes = "user/likes"
        case postComments = "post/comments"
        case searchUsername = "search/username"
        case relatedPosts = "user/related"
    }

    public class func request<T: Mappable>(_ type: T.Type, _ requestEndpoint: RequestEndpoint, _ headers: [String: String]? = nil, _ method: HTTPMethod = .get, completion: @escaping (_ success: Bool, T?) -> Void) {

        var url = Constants.URLS.hostUrl
        
        url.appendPathComponent(requestEndpoint.rawValue)
        
        Alamofire.request(url, method: method, parameters: nil, headers: headers).responseObject { (response: DataResponse<T>) in
            if let object = response.result.value {
                completion(true, object)
            } else {
                completion(false, nil)
            }
        }
    }
    
    public class func uploadData(with image: UIImage, _ requestEndpoint: RequestEndpoint, _ headers: [String: String]? = nil, completion: @escaping (_ success: Bool, [String: Any]?) -> Void) {
        var url = Constants.URLS.hostUrl
        
        url.appendPathComponent(requestEndpoint.rawValue)
        
        guard let imageRepresentation = UIImageJPEGRepresentation(image, 0.5) else {
            return
        }
        
        // swiftlint:disable multiple_closures_with_trailing_closure
        upload(multipartFormData: { formData  in
            formData.append(imageRepresentation, withName: "image", fileName: "image.jpeg", mimeType: "image/jpeg")
        }, usingThreshold: 1000000, to: url, method: .post, headers: headers) { result in
            switch result {
            case .success(let response, _, _):
                response.responseJSON(completionHandler: { response in
                    if let json = response.result.value as? [String: Any] {
                        completion(true, json)
                    } else {
                        completion(false, nil)
                    }
                })
            case .failure(let error):
                completion(false, nil)
                print(error)
            }
        }
    }
    
    public class func request(_ requestEndpoint: RequestEndpoint, _ headers: [String: String]? = nil, _ parameters: Parameters?, _ method: HTTPMethod = .get, completion: @escaping (_ success: Bool, [String: Any]?) -> Void) {
        
        var url = Constants.URLS.hostUrl
        
        url.appendPathComponent(requestEndpoint.rawValue)
        
        Alamofire.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            if let json = response.result.value as? [String: Any] {
                completion(true, json)
            } else {
                completion(false, nil)
            }
        }
    }
}
