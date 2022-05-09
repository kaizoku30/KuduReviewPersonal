//
//  Constants.swift
//  Kudu
//
//  Created by Admin on 02/05/22.
//

import Foundation

class Constants
{
    struct BasicAuthCredentials {
        static var apiUserNameAndPass = "vida:vida@123"
        static var b64String:String {
            get {
                let data = apiUserNameAndPass.data(using: String.Encoding.utf8)
                return data?.base64EncodedString() ?? ""
            }
        }
    }
    
    struct S3BucketCredentials{
        static let s3PoolApiKey = "us-east-1:ddd74fa1-9d1a-4370-af14-26980e40e7a2"
        static let s3BucketName = "app-development"
        static let s3BaseUrl = "https://app-development.s3.amazonaws.com/"
    }
    
    struct StatusCode {
        static let BLOCKED = 401
        static let DELETED = 401
      //  static let OTP_EXPIRED = 400
    }
    
    enum NotificationObservers:String {
        case resetLoginState
        case videoThumbnailsUpdated
    }
    
    struct APIKeys {
        static let profilePicture = "profilePicture"
    }
    
    enum MediaTypes : String {
        case kImage  = "public.image"
        case kVideo  = "public.movie"
        
        var intVal:Int {
            switch self {
            case .kImage:
                return 1
            case .kVideo:
                return 2
            }
        }
    }

    enum S3MediaType: Int {
        case image = 1
        case video = 2
    }
}
