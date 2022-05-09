//
//  PhotoAndVideoController.swift

//
//  Created by Admin on 23/03/21.

//
import UIKit
import TLPhotoPicker

struct AWSUploadRequest:Codable {
    var awsLink = ""
    var uploaded:Bool = false
    var videoLocalURL:URL? = nil
    var uploadIdentifier:String = UUID().uuidString
}

struct TLImageUploadRequest {
    let asset:TLPHAsset?
    let awsRequest:AWSUploadRequest
}

final class PhotoVideoUploadHandler {
    
    static func uploadVideoOnAws(path: URL,uploadId:String,progress:@escaping (CGFloat)->(),handler:@escaping (Bool,String?,String?)->()) {
        var request = AWSUploadRequest(awsLink: "", uploaded: false, videoLocalURL: path, uploadIdentifier: uploadId)
        AWSUploadCache.addAWSRequest(request)
        //DataManager.shared.awsRequests?.append(AWSUploadRequest(awsLink: "", uploaded: false, localURL: path))
        AWSUploadController.uploadTheVideoToAWS(videoUrl: path, progress: {
            (progress) in
            debugPrint("Upload Progress :\(progress)")
        }, completion: {
            (awsUploadLink,error) in
            if error.isNil && awsUploadLink.isNotNil
            {
                debugPrint("Uploaded at \(awsUploadLink ?? "")")
                request.uploaded = true
                request.awsLink = awsUploadLink!
                AWSUploadCache.updateAWSRequest(request)
                handler(true,awsUploadLink,nil)
            }
            else
            {
                AWSUploadCache.removeAWSRequest(request)
                handler(false,nil,error?.localizedDescription)
            }
        })
    }
    
    static func uploadImageOnAws(imageUploadReqID:String,image:UIImage,compression:Double = 1,progress:@escaping (Double?)->(),handler:@escaping (Bool,String?,String?)->()) {
        var request = AWSUploadRequest(awsLink: "", uploaded: false, videoLocalURL: nil, uploadIdentifier: imageUploadReqID)
        //DataManager.shared.awsRequests?.append(AWSUploadRequest(awsLink: "", uploaded: false, localURL: nil,imageIdentifier: imageUploadReqID))
        AWSUploadController.uploadTheImageToAWS(compression:compression,image: image, completion: {
            (awsUploadLink,error) in
            if error.isNil && awsUploadLink.isNotNil
            {
                debugPrint("Uploaded at \(awsUploadLink ?? "")")
                request.uploaded = true
                request.awsLink = awsUploadLink!
                AWSUploadCache.updateAWSRequest(request)
                handler(true,awsUploadLink,nil)
            }
            else
            {
                AWSUploadCache.removeAWSRequest(request)
                handler(false,nil,error?.localizedDescription)
            }
            
        }, progress: progress)
    }
}

public struct FileSize {
  
  public let bytes: Int64
  
  public var kilobytes: Double {
    return Double(bytes) / 1_024
  }
  
  public var megabytes: Double {
    return kilobytes / 1_024
  }
  
  public var gigabytes: Double {
    return megabytes / 1_024
  }
  
  public init(bytes: Int64) {
    self.bytes = bytes
  }
  
  public func getReadableUnit() -> String {
    
    switch bytes {
    case 0..<1_024:
      return "\(bytes) bytes"
    case 1_024..<(1_024 * 1_024):
      return "\(String(format: "%.2f", kilobytes)) kb"
    case 1_024..<(1_024 * 1_024 * 1_024):
      return "\(String(format: "%.2f", megabytes)) mb"
    case (1_024 * 1_024 * 1_024)...Int64.max:
      return "\(String(format: "%.2f", gigabytes)) gb"
    default:
      return "\(bytes) bytes"
    }
  }
}
