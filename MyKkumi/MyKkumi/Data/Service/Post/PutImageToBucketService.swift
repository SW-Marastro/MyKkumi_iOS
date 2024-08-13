//
//  PutImageToBucketService.swift
//  MyKkumi
//
//  Created by 최재혁 on 8/9/24.
//

import Foundation
import Moya

public var putImageToBucketProvider = MoyaProvider<PutImageToBucketService>()

public enum PutImageToBucketService {
    case putImage(url : String, image : Data)
}

extension PutImageToBucketService : TargetType {
    public var baseURL: URL {
        switch self {
        case .putImage(let url, _) : return URL(string: url)!
        }
    }
    
    public var path: String {
        switch self {
        case .putImage(_, _) : return ""
        }
    }
    
    public var method : Moya.Method {
        switch self {
        case .putImage : return .put
        }
    }
    
    public var task: Task {
        switch self {
        case .putImage(_, let imageData) :
            return .requestData(imageData)
        }
    }
    
    //requestIntercepter에 header 구현되어있음
    public var headers: [String : String]? {
        switch self {
        default :
            return ["Content-Type": "application/octet-stream"]
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
}
