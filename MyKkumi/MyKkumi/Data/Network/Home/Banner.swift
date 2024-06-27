//
//  Banner.swift
//  MyKkumi
//
//  Created by 최재혁 on 6/27/24.
//

import Foundation
import Moya

public var bannerProvier = MoyaProvider<Banner>()

public enum BannerError : Error {
    case unknownError(ErrorVO)
}

public enum Banner {
    case getBanners
    case getBanner(String)
}

extension Banner : TargetType {
    public var baseURL: URL {return URL(string : NetworkConfiguration.baseUrl)!}
    
    public var path: String {
        switch self {
        case .getBanners : return NetworkConfiguration.banners
        case .getBanner(let id) : return NetworkConfiguration.banners + id
        }
    }
    
    public var method: Moya.Method {
        return .get
    }
    
    public var task: Task {
        return .requestPlain
    }
    
    public var headers: [String : String]? {
        return ["Content-Type" : "applicatino/json"]
    }
    
    public var sampleData: Data {
        return Data()
    }
}
