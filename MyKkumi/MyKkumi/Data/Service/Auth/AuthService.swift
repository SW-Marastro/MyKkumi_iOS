//
//  Auth.swift
//  MyKkumi
//
//  Created by 최재혁 on 7/16/24.
//

import Foundation
import Moya

public var authProvider = MoyaProvider<Auth>()

public enum AuthError : Error {
    case unknownError(ErrorVO)
    case CONFLICT
    case NOTFOUND
    case INVALIDTOKEN
}

public enum Auth {
    case signinKakao(AuthVO)
    case signinApple(AppleAuth)
    case getUserData
    case patchUser(PatchUserVO)
    case refreshToken(RefreshToekn)
    case getPresignedUrl
    case reportUser(String)
}

extension Auth : TargetType {
    public var baseURL : URL {return URL(string : NetworkConfiguration.baseUrl)!}
    
    public var path : String {
        switch self {
        case .signinKakao(_) : return NetworkConfiguration.signinKakao
        case .signinApple(_) : return NetworkConfiguration.signinApple
        case .getUserData : return NetworkConfiguration.getUserData
        case .patchUser(_) : return NetworkConfiguration.patchUser
        case .refreshToken(_) : return NetworkConfiguration.getToken
        case .getPresignedUrl : return NetworkConfiguration.profileImagePresigned
        case .reportUser(_) : return NetworkConfiguration.reportUser
        }
    }
    
    public var method : Moya.Method {
        switch self {
        case .getUserData, .getPresignedUrl : return .get
        case .signinKakao(_), .signinApple(_), .refreshToken, .reportUser(_)  : return .post
        case .patchUser(_) : return .patch
        }
    }
    
    public var task : Task {
        switch self {
        case .signinKakao(let auth) :
            return .requestJSONEncodable(auth)
        case .signinApple(let auth) :
            return .requestJSONEncodable(auth)
        case .getUserData :
            return .requestPlain
        case .getPresignedUrl :
            var params : [String: Any] = [:]
            params["extension"] = "jpeg"
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .patchUser(let user) :
            return .requestJSONEncodable(user)
        case .refreshToken(let refreshToken) :
            return .requestJSONEncodable(refreshToken)
        case .reportUser(let userId) :
            let reportBody = ReportUserBody(userUuid: userId, reason: "ETC", content: "그냥 싫습니다.")
            return .requestJSONEncodable(reportBody)
        }
    }
    
    public var headers : [String : String]? {
        switch self {
        case .patchUser(_), .getPresignedUrl, .reportUser(_), .getUserData :
            var accessToken = KeychainHelper.shared.load(key: "accessToken")!
            accessToken = "Bearer " + accessToken
            return ["Content-Type" : "application/json",
                    "Authorization" : accessToken]
        default :
            return ["Content-Type" : "application/json"]
        }
    }
    
    public var sampleData : Data {
        return Data()
    }
}
