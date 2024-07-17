//
//  AuthVO.swift
//  MyKkumi
//
//  Created by 최재혁 on 7/16/24.
//

import Foundation

public struct AuthVO : Codable {
    let refreshToken: String
    let accessToken: String
    
    enum CodingKeys : String, CodingKey {
        case refreshToken
        case accessToken
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        refreshToken = try values.decode(String.self, forKey: .refreshToken)
        accessToken = try values.decode(String.self, forKey: .accessToken)
    }
    
    public init(refreshToken: String, accessToken: String) {
        self.refreshToken = refreshToken
        self.accessToken = accessToken
    }
}

public struct OAuthToken {
    let refreshToken: String
    let accessToken: String
    
    public init(refreshToken: String, accessToken: String) {
        self.refreshToken = refreshToken
        self.accessToken = accessToken
    }
}
