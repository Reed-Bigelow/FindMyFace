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

class RestClientService: NSObject {

    public class func request<T>(_ type: T.Type, _ headers: [String: String]? = nil, completion: @escaping (_ success: Bool, Any?) -> Void) {
        
        // MARK: - Function Properties
        var url = Constants.URLS.hostUrl
        var method: HTTPMethod = .get
    
        switch type {
        case is Feed.Type:
            url.appendPathComponent("feed/")
        default:
            break
        }
        
        Alamofire.request(url, method: method, parameters: nil, headers: headers).responseObject { (response: DataResponse<Feed>) in
            if let feed = response.result.value {
                completion(true, feed)
            } else {
                completion(false, nil)
            }
        }
    }
    
    public class func uploadData(with image: UIImage, _ headers: [String: String]? = nil) {
        let url = Constants.URLS.hostUrl.appendingPathComponent("upload")
        
        guard let imageRepresentation = UIImageJPEGRepresentation(image, 1.0) else {
            return
        }
        
        // swiftlint:disable multiple_closures_with_trailing_closure
        upload(multipartFormData: { formData  in
            formData.append(imageRepresentation, withName: "image", mimeType: "image/jpg")
        }, usingThreshold: 1000, to: url, method: .post, headers: headers) { result in
            print(result)
        }
    }
}
