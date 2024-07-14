//
//  Post.swift
//  MyKkumi
//
//  Created by 최재혁 on 7/2/24.
//

import Foundation
import Moya

public var postProvier = MoyaProvider<Post>()

public enum PostError : Error {
    case ENCODING_ERROR
    case DECODING_ERROR
    case INVALID_VALUE
    case unknownError(ErrorVO)
}

public enum Post {
    case getPost(String?)
}

extension Post : TargetType {
    public var baseURL: URL {return URL(string : NetworkConfiguration.baseUrl)!}
    
    public var path: String {
        switch self {
        case .getPost(_) : return NetworkConfiguration.getPost
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getPost(_) : return .get
        }
    }
    
    public var task: Task {
        switch self {
        case .getPost(let cursor) :
            var params : [String: Any] = [:]
            params["limit"] = 5
            params["cursor"] = cursor
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
    
    public var headers: [String : String]? {
        return ["Content-Type" : "application/json"]
    }
    
    public var sampleData: Data {
        return Data()
    }
    
}
