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
    case signinApple(AppleAuth)
    case getUserData
   // case patchUser(PatchUserVO)
    case getToken
}

extension Auth : TargetType {
    public var baseURL : URL {return URL(string : NetworkConfiguration.baseUrl)!}
    
    public var path : String {
        switch self {
        case .signinKakao(_) : return NetworkConfiguration.signinKakao
        case .signinApple(_) : return NetworkConfiguration.signinApple
        case .getUserData : return NetworkConfiguration.getUserData
        //case .patchUser(_) : return NetworkConfiguration.patchUser
        case .getToken : return NetworkConfiguration.getToken
        }
    }
    
    public var method : Moya.Method {
        switch self {
        case .getUserData : return .get
        case .signinKakao(_), .signinApple(_), .getToken  : return .post
        //case .patchUser(_) : return .post
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
//        case .patchUser(let user) :
//            var multipartData = [MultipartFormData]()
//                        
//            if let nickname = user.nickname?.data(using: .utf8) {
//                multipartData.append(MultipartFormData(provider: .data(nickname), name: "nickname"))
//            }
//            
//            if let profileImage = user.profilImage {
//                
////                multipartData.append(MultipartFormData(provider: .data(imageData), name: "profileImage", fileName: "profile.jpg", mimeType: "image/jpeg"))
//            }
//            
//            if let introduction = user.introduction?.data(using: .utf8) {
//                multipartData.append(MultipartFormData(provider: .data(introduction), name: "introduction"))
//            }
//            
//            if let categoryIds = user.categoryIds {
//                for categoryId in categoryIds {
//                    let categoryIdData = "\(categoryId)".data(using: .utf8)!
//                    multipartData.append(MultipartFormData(provider: .data(categoryIdData), name: "categoryIds[]"))
//                }
//            }
//            
//            return .uploadMultipart(multipartData)
        case .getToken :
            return .requestPlain
        }
    }
    
    public var headers : [String : String]? {
        return ["Content-Type" : "application/json"]
    }
    
    public var sampleData : Data {
        return Data()
    }
}
