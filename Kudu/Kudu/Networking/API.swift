
import Foundation
import Alamofire
import SystemConfiguration


typealias SuccessCompletionBlock<T> = ( _ response: T ) -> Void
typealias FailureCompletionBlock = ( _ error : String ) -> Void
typealias ErrorFailureCompletionBlock = ( _ status: ResponseStatus ) -> Void

/// API request method used for all requests
struct Api {
    
    static func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
    
    
    static var session: Session?
    
    static func requestNew<T: Codable>(endpoint: Endpoint, type: T.Type, successHandler: @escaping SuccessCompletionBlock<T>, failureHandler: @escaping ErrorFailureCompletionBlock) {
        if isConnectedToNetwork() {
            guard let url = URL(string: endpoint.path) else {
                failureHandler(.init(msg: "Error in request url"))
                return
            }
            let credentials = URLCredential()

            print("NEW REQUEST STARTED AT: \(Date())")
            
            let customRefreshRetrier: RequestRetrier & RequestAdapter = CustomRequestRetrier(endpoint: endpoint)
            let interceptor = Interceptor(adapter: customRefreshRetrier, retrier: customRefreshRetrier)
            AF.request(url,
                       method: endpoint.method,
                       parameters: endpoint.parameters,
                       encoding: endpoint.encoding,
                       headers: endpoint.header,
                       interceptor: interceptor)
                .validate(contentType:["application/json"])
                .authenticate(with: credentials)
                .responseJSON { (response) in
                    if endpoint.method == .get && response.request?.url != nil
                    {
                        debugPrint("Request GET URL with Parameters : \((response.request?.url)!)")
                    }
                    print("NEW REQUEST: \n\n Now: \(Date()) \n Url: \(endpoint.path) \n Parameters: \(endpoint.parameters) \n Value: \n \(String(describing: response.value)) \n Header: \(String(describing: endpoint.header)) \n Validation Error: \(String(describing: response.error?.localizedDescription)) \n\n")
                    
                    switch response.result {
                    
                    case .failure(let error):
                        
                        let errorMessage = error.localizedDescription
                        failureHandler(.init(msg: errorMessage))
                        return
                        
                    case .success:
                        handleSuccessNew(response: response, successHandler: successHandler, failureHandler: failureHandler)
                    }
                }
        }else {
            failureHandler(.init(code: 100, msg: "No Internet Connection"))
        }
    }
    
    /// Parses response to the generic requested type
    static private func handleSuccessNew<T: Codable>(response: DataResponse<Any, AFError>, successHandler: @escaping SuccessCompletionBlock<T>, failureHandler: @escaping ErrorFailureCompletionBlock) {
        if let value = response.data {
            do {
                let emptyDataResponse = try JSONDecoder().decode(EmptyDataResponse.self, from: value)
                
               // let decodableObject = try JSONDecoder().decode(T.self, from: value)
             //   successHandler(decodableObject)
                
                //MARK: HANDLE DELETION/BLOCKED ACROSS APP AFTER CODES ARE PROVIDED FROM BACKEND
                //emptyDataResponse.statusCode == Constants.StatusCode.BLOCKED || emptyDataResponse.statusCode == Constants.StatusCode.DELETED ||
                if emptyDataResponse.type == "SESSION_EXPIRED" || emptyDataResponse.type == "INVALID_TOKEN" {
                   // NotificationCenter.postNotificationForObservers(.resetLoginState)
                    handleUserDeletedOrBlocked(msg:emptyDataResponse.message ?? "LS.Errors.somethingWentWrong")
                } else {
                    let decodableObject = try JSONDecoder().decode(T.self, from: value)
                    successHandler(decodableObject)
                }

            }catch let errorCaught {
               
                failureHandler(.init(msg: errorCaught.localizedDescription,errorObject: errorCaught as? DecodingError))
            }
        }else {
            failureHandler(.init(msg: "Unable to get body data"))
        }
    }
    
    static func handleUserDeletedOrBlocked(msg:String){
        //Router.shared.goToLoginVC(msg:msg)
    }
    
    static func multipartFormData(endPoint:Endpoint, params: [String: Any],success: @escaping (_ response: Any) -> Void, failure: @escaping (_ error: String) -> Void, connectionFailed: @escaping (_ error: String) -> Void) {
        
        guard let url = URL(string: endPoint.path) else {
            failure("Error in request url")
            //            failureHandler(.init("Error in request url"))
            return
        }
        
        let request = try! URLRequest(url: url,method: endPoint.method)
        AF.upload(multipartFormData: { multiPart in
            for (key, value) in params {
                if let temp = value as? String {
                    multiPart.append(temp.data(using: .utf8)!, withName: key)
                }else if let temp = value as? Int {
                    multiPart.append("\(temp)".data(using: .utf8)!, withName: key)
                }else if let temp = value as? NSArray {
                    temp.forEach({ element in
                        let keyObj = key + "[]"
                        if let string = element as? String {
                            multiPart.append(string.data(using: .utf8)!, withName: keyObj)
                        } else
                        if let num = element as? Int {
                            let value = "\(num)"
                            multiPart.append(value.data(using: .utf8)!, withName: keyObj)
                        }
                    })
                }else if let data = value as? Data {
                    let randomStr = ""//String.randomString(length: 16)
                    multiPart.append(data, withName: key, fileName: key + randomStr + ".jpg", mimeType: "image/jpeg")
                }
            }
        }, with:request)
        .uploadProgress(queue: .main, closure: { progress in
            //Current upload progress of file
            print("Upload Progress: \(progress.fractionCompleted)")
        })
        .responseJSON(completionHandler: { response in
            //Do what ever you want to do with response
            print("NEW REQUEST: \n\n Now: \(Date()) \n Url: \(endPoint.path) \n Parameters: \(endPoint.parameters) \n Value: \n \(String(describing: response.value)) \n Header: \(String(describing: endPoint.header)) \n Validation Error: \(String(describing: response.error?.localizedDescription)) \n\n")
            
            switch response.result {
            
            case .failure(let error):
                
                let errorMessage = error.localizedDescription
                failure(errorMessage)
                return
                
            case .success(_):
                debugPrint(response)
                if response.response?.statusCode == 200 {
                    if let value = response.data {
                        
                        if let jsonData = try? JSONSerialization.jsonObject(with: value, options: .fragmentsAllowed) {
                            print(jsonData)
                            //                            print("Response: \n",String(data: jsonData, encoding: String.Encoding.utf8) ?? "nil")
                            success(jsonData as Any)
                        }
                        //                        success(value as Any)
                    }
                } else {
                    if let val = response.data {
                        let res = val as AnyObject
                        if let msg = res.object(forKey: "Message") as? String{
                            failure(msg)
                        }else {
                            failure("")
                        }
                    }else {
                        failure("Invalid response")
                        print("didn't get value from server")
                    }
                    
                }
                
            }
        })
    }
    
    static func downloadFile(with url:URL,progressBlock:((_ progress:CGFloat)->())?,completion:((_ url:URL?,_ error:Error?)->())?){
        let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory,in: .userDomainMask,options: .removePreviousFile)
    
//        FileManager.init().clearTmpDirectory()

        AF.download(
            url,
            method: .get,
            encoding: JSONEncoding.default,
            headers: nil,
            to: destination).downloadProgress(closure: { (progress) in
                //progress closure
                print("download",progress)
                progressBlock?(CGFloat(progress.fractionCompleted))
            }).response(completionHandler: { (defaultDownloadResponse) in
                //here you able to access the DefaultDownloadResponse
                //result closure
                completion?(defaultDownloadResponse.fileURL,defaultDownloadResponse.error)
//                print("url is ",defaultDownloadResponse.fileURL)
            })
    }
}

extension FileManager {
    func clearTmpDirectory() {
        do {
            let tmpDirectory = try contentsOfDirectory(atPath: NSTemporaryDirectory())
            try tmpDirectory.forEach {[unowned self] file in
                let path = String.init(format: "%@%@", NSTemporaryDirectory(), file)
                try self.removeItem(atPath: path)
            }
        } catch {
            print(error)
        }
    }
}
