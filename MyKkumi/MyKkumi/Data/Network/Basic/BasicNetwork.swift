//
//  BasicNetwork.swift
//  MyKkumi
//
//  Created by 최재혁 on 6/18/24.
//

import Foundation
import Moya

public var titleProvider = MoyaProvider<BasicTitle>()

public enum BasicTitle {
    case getTitle
}

extension BasicTitle : TargetType {
    public var baseURL : URL { return URL(string:"http://dev.api.mykkumi.com/v1")!}
    
    public var path: String {
        switch self {
        case.getTitle : return "/home"
        }
    }
    
    public var method: Moya.Method {
        return .get
    }
    
    public var task: Task {
        return .requestPlain
    }
    
    public var headers: [String : String]? {
        return ["Content-Type" : "application/json"]
    }
    
    public var sampleData: Data {
        return Data()
    }
}


