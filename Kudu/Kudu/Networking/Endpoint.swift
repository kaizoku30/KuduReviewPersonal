

import Foundation
import Alamofire

enum Endpoint {
    //MARK: PRELOGIN END POINTS
    case payment(cardToken:String)
    
    /// GET, POST or PUT method for each request
    var method:Alamofire.HTTPMethod {
        switch self {
        case .payment:
            return .post
        }
    }
    
    /// URLEncoding used for GET requests and JSONEncoding for POST and PUT requests
    var encoding:Alamofire.ParameterEncoding {
        switch self.method {
        case .get:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }
    
    /// URL string for each request
    var path: String {
        switch self {
        case .payment:
            return "https://api.sandbox.checkout.com/payments"
        }
    }
    
    /// parameters Dictionary for each request
    var parameters:[String:Any] {
        switch self {
        case .payment(let cardToken):
            return ["source":["type":"token","token":cardToken],"amount":1,"currency":"USD","reference":"ORD=5023-4E38"]
        }
    }
    
    /// http header for each request (if needed)
    var header:HTTPHeaders? {
        var headers = ["platform":"IOS","timezone":"0","api_key":"1234","language":"en"]
        switch self {
        case .payment:
            headers = [:]
            headers["authorization"] = "sk_test_146d56ed-4dcd-493a-9db2-866c924c0bba"
            break
        }
        return HTTPHeaders(headers)
    }
}
