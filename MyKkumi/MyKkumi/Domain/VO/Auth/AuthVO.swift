//
//  AuthVO.swift
//  MyKkumi
//
//  Created by 최재혁 on 7/16/24.
//

import Foundation

public struct AuthVO : Codable {
    let refreshToken: String?
    let accessToken: String
    
    enum CodingKeys : String, CodingKey {
        case refreshToken
        case accessToken
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        refreshToken = try values.decodeIfPresent(String.self, forKey: .refreshToken)
        accessToken = try values.decode(String.self, forKey: .accessToken)
    }
    
    public init(refreshToken: String, accessToken: String) {
        self.refreshToken = refreshToken
        self.accessToken = accessToken
    }
}

public struct OAuthToken: Codable {
    let refreshToken: String
    let accessToken: String
    
    public init(refreshToken: String, accessToken: String) {
        self.refreshToken = refreshToken
        self.accessToken = accessToken
    }
}

public struct AppleAuth : Codable {
    let authorizationCode : String
    
    public init(authorizationCode: String) {
        self.authorizationCode = authorizationCode
    }
    
    enum CodingKeys : String, CodingKey {
        case authorizationCode
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        authorizationCode = try values.decode(String.self, forKey: .authorizationCode)
    }
}

public struct UserVO : Codable {
    let nickname : String?
    let email : String
    let introduction : String?
    let profilImage : String?
    
    enum CodingKeys : String, CodingKey {
        case nickname
        case email
        case introduction
        case profilImage
    }
    
    public init(nickname: String?, email: String, introduction: String?, profilImage: String?) {
        self.nickname = nickname
        self.email = email
        self.introduction = introduction
        self.profilImage = profilImage
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        nickname = try values.decodeIfPresent(String.self, forKey: .nickname)
        email = try values.decode(String.self, forKey: .email)
        introduction = try values.decodeIfPresent(String.self, forKey: .introduction)
        profilImage = try values.decodeIfPresent(String.self, forKey: .profilImage)
    }
}

public struct PatchUserVO : Codable  {
    let nickname : String?
    let introduction : String?
    let profilImageURL : String?
    let categoryIds : [Int]?
    
    enum CodingKeys : String, CodingKey {
        case nickname
        case introduction
        case profilImageURL = "profileImage"
        case categoryIds
    }
    
    public init(nickname: String?, introduction: String?, profilImage: String?, categoryIds: [Int]?) {
        self.nickname = nickname
        self.introduction = introduction
        self.profilImageURL = profilImage
        self.categoryIds = categoryIds
    }
}

public struct RefreshToekn : Codable {
    let refreshToken : String
}

public struct ReAccessToken : Codable {
    let accessToken : String
    
    enum CodingKeys : String, CodingKey {
        case accessToken
    }
}

public struct ReportUserBody : Codable {
    let userUuid : String
    let reason : String
    let content : String
    
    public init(userUuid: String, reason: String, content: String) {
        self.userUuid = userUuid
        self.reason = reason
        self.content = content
    }
}