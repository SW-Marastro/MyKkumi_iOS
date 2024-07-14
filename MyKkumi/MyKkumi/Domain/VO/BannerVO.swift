//
//  BannerVO.swift
//  MyKkumi
//
//  Created by 최재혁 on 6/27/24.
//

import Foundation

public struct BannersVO : Codable {
    let banners : [BannerVO]
}

public struct BannerVO : Codable {
    let id : Int
    let imageURL : String
    
    enum CodingKeys : String, CodingKey {
        case id
        case imageURL = "imageUrl"
    }
    
    public init(from decoder : Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        imageURL = try values.decode(String.self, forKey: .imageURL)
    }
}

public struct BannerInfoVO : Codable {
    let id : Int
    let imageURL : String
    
    enum CodingKeys : String, CodingKey {
        case id
        case imageURL = "imageUrl"
    }
    
    public init(from decoder : Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        imageURL = try values.decode(String.self, forKey: .imageURL)
    }
}
