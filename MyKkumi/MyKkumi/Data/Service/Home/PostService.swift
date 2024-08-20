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
    case report(Int)
}

extension Post : TargetType {
    public var baseURL: URL {return URL(string : NetworkConfiguration.baseUrl)!}
    
    public var path: String {
        switch self {
        case .getPost(_) : return NetworkConfiguration.getPost
        case .report(_ ) : return NetworkConfiguration.reportPost
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getPost(_) : return .get
        case .report(_) : return .post
        }
    }
    
    public var task: Task {
        switch self {
        case .getPost(let cursor) :
            var params : [String: Any] = [:]
            params["limit"] = 5
            params["cursor"] = cursor
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .report(let postId) :
            let body  = ReportBody(postId: postId, reason: "ETC", content: "남을 비방하는 내용이 포함된 포스트인 것같습니다.")
            return .requestJSONEncodable(body)
        }
    }
    
    public var headers: [String : String]? {
//        var accessToken = KeychainHelper.shared.load(key: "accessToken")!
//        accessToken = "Bearer " + accessToken
        return ["Content-Type" : "application/json"]
    }
    
    public var sampleData: Data {
        return Data()
    }
    
}
