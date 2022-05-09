

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
//        case .usernameAvailable,.getQuestions,.emailExistence,.getRegionList,.getActivityList,.getLocationList,.getExperienceList,.getArticlesList,.getHomePageActivityList,.getRelatedArticlesList,.getRelatedExperienceList,.getLocationDetail,.searchLocation,.getExperienceDetail,.getDiscoveryTravelers,.getRecentlySavedItems,.getList,.getListDetailArticle,.getListDetailLocation,.getListDetailExperience,.getProfile,.getProfileLocations,.getProfileExperiences,.getUserRegionsActivities,.getRecentSearch,.elasticSearch,.getFollowers,.getLocationMapListings,.getMapExperienceList,.getMapArticlesList,.getLocationDetailOpenAPI,.getExperienceDetailOpenAPI,.getArticleDetail,.getNotes,.getNoteDetail:
//            return .get
//        case .updateRegionActivityPref,.editExperience,.addItemToList,.incrementSearchCount,.moveItemInList,.updateProfile,.addRecentSearch,.changePassword,.pinLocation,.editNote:
//            return .put
//        case .deleteExperience,.deleteRecentSearch,.removeFollower,.deleteNote:
//            return .delete
        }
    }
    
    /// URLEncoding used for GET requests and JSONEncoding for POST and PUT requests
    var encoding:Alamofire.ParameterEncoding {
        
//        switch self {
//        case .getLocationList,.getExperienceList,.getRelatedExperienceList,.searchLocation,.getRecentSearch,.getLocationMapListings,.getArticlesList:
//            return URLEncoding(arrayEncoding:.noBrackets,boolEncoding: .literal)
//        default:
//            break
//        }
//
        switch self.method {
        case .get:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }
    
    /// URL string for each request
    var path: String {
        //let interMediate = "/v1/user/"
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
        
//        if let language = AppUserDefaults.value(forKey: .selectedLanguage).string,!language.isEmpty {
//            updatedHeaders["language"] = language
//        } else{
//            updatedHeaders["language"] = "en"
//        }
        
        switch self {
        case .payment:
            headers = [:]
            headers["authorization"] = "sk_test_146d56ed-4dcd-493a-9db2-866c924c0bba"
            break
        
        //    headers["authorization"] = "Bearer \(DataManager.shared.loginResponse?.accessToken ?? "")"
        }
        
        return HTTPHeaders(headers)
    }
}
