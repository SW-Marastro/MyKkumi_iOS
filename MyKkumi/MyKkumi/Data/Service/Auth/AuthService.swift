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
}

public enum Auth {
    case signinKakao(AuthVO)
}

extension Auth : TargetType {
    public var baseURL : URL {return URL(string : NetworkConfiguration.baseUrl)!}
    
    public var path : String {
        switch self {
        case .signinKakao(_) : return NetworkConfiguration.sininKakao
        }
    }
    
    public var method : Moya.Method {
        switch self {
        case .signinKakao(_) : return .post
        }
    }
    
    public var task : Task {
        switch self {
        case .signinKakao(let auth) :
            return .requestJSONEncodable(auth)
        }
    }
    
    public var headers : [String : String]? {
        return ["Content-Type" : "application/json"]
    }
    
    public var sampleData : Data {
        return Data()
    }
}
