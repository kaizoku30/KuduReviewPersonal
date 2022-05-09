//
//  File.swift
//  VIDA
//
//  Created by Admin on 11/02/22.
//

import Foundation

struct AWSUploadCache {
    static func addAWSRequest(_ req:AWSUploadRequest)
    {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(req) {
            AppUserDefaults.saveWithUniqueKey(value: encoded, forKey: req.uploadIdentifier)
            var pendingRequestIds = AppUserDefaults.value(forKey: .pendingAWSRequests) as? [String] ?? []
            pendingRequestIds.append(req.uploadIdentifier)
            AppUserDefaults.save(value: pendingRequestIds, forKey: .pendingAWSRequests)
        }
    }
    static func updateAWSRequest(_ req:AWSUploadRequest)
    {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(req) {
            debugPrint("Updated AWS Req in Cache : \(req.awsLink)")
            AppUserDefaults.saveWithUniqueKey(value: encoded, forKey: req.uploadIdentifier)
        }
    }
    static func removeAWSRequest(_ req:AWSUploadRequest)
    {
        AppUserDefaults.removeValue(forUniqueKey: req.uploadIdentifier)
        var pendingRequestIds = AppUserDefaults.value(forKey: .pendingAWSRequests) as? [String] ?? []
        pendingRequestIds.remove(object: req.uploadIdentifier)
        AppUserDefaults.save(value: pendingRequestIds, forKey: .pendingAWSRequests)
    }
    static func deleteUnusedAWSFiles()
    {
        let unusedUploadIds = AppUserDefaults.value(forKey: .pendingAWSRequests) as? [String] ?? []
        unusedUploadIds.forEach({
            let request = fetchAwsRequest(uploadId: $0)
            if let object = request
            {
                removeAWSRequest(object)
                var updatedUploadIds = unusedUploadIds
                updatedUploadIds.remove(object: $0)
                AppUserDefaults.save(value: updatedUploadIds, forKey: .pendingAWSRequests)
                if object.awsLink != "" { deleteOnAWS(awsLink: object.awsLink) }
            }
        })
        logCacheStatus()
    }
    
    static func logCacheStatus()
    {
        let pendingRequests = AppUserDefaults.value(forKey: .pendingAWSRequests) as? [String] ?? []
        debugPrint("Pending AWS Req Count : \(pendingRequests.count)")
    }
    
    private static func fetchAwsRequest(uploadId:String)->AWSUploadRequest?
    {
        let data = AppUserDefaults.value(forUniqueKey: uploadId)
        guard let data = data as? Data else { return nil }
        let decoder = JSONDecoder()
        let decoded = try? decoder.decode(AWSUploadRequest.self, from: data)
        return decoded
    }
    
    private static func deleteOnAWS(awsLink:String)
    {
        DispatchQueue.global(qos: .background).async {
            guard let fileName = awsLink.components(separatedBy: CommonStrings.forwdSlash).last else { return }
            AWSUploadController.deleteS3Object(fileName: fileName, handler: {
                (deleted) in
                if deleted
                {
                    debugPrint("Deleted AWS Req /Asset at : \(awsLink)")
                }
            })
        }
    }
}
