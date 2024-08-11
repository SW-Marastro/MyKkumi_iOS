//
//  PostService.swift
//  MyKkumi
//
//  Created by 최재혁 on 8/8/24.
//

import Foundation
import Moya

public var makePostProvider = MoyaProvider<MakePost>(session : session)

public enum MakePostError : Error {
    case unknownError(ErrorVO)
    case Forbidden
    case Unauthorized
    case BadReqeust
}

public enum MakePost {
    case getCategory
    case getPresignedURL
    case putImage(url : String, image : Data)
    case uploadPost(MakePostVO)
    case deletePost(String)
}

extension MakePost : TargetType {
    public var baseURL: URL {
        switch self {
        case .putImage(let url, _) : return URL(string: url)!
        default : return URL(string : NetworkConfiguration.baseUrl)!
        }
    }
    
    public var path: String {
        switch self {
        case .getCategory : return NetworkConfiguration.getCategory
        case .getPresignedURL : return NetworkConfiguration.getPresignedURL
        case .putImage(let url, _) : return ""
        case .uploadPost : return NetworkConfiguration.uploadPost
        case .deletePost(let postid) : return NetworkConfiguration.deletePost + postid
        }
    }
    
    public var method : Moya.Method {
        switch self {
        case .getCategory, .getPresignedURL : return .get
        case .uploadPost : return .post
        case .deletePost : return .delete
        case .putImage : return .put
        }
    }
    
    public var task: Task {
        switch self {
        case .getCategory, .deletePost :
            return .requestPlain
        case .getPresignedURL :
            var params : [String: Any] = [:]
            params["extension"] = "jpeg"
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .uploadPost(let post) :
            return .requestJSONEncodable(post)
        case .putImage(_, let imageData) :
            return .requestData(imageData)
        }
    }
    
    //requestIntercepter에 header 구현되어있음
    public var headers: [String : String]? {
        switch self {
        case .putImage(_, _) :
            return ["Content-Type": "application/octet-stream"]
        default : return ["Content-Type": "application/json"]
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
}

extension MakePost {
    public var validationType: ValidationType {
      return .successCodes
    }
}
