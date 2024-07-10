//
//  PostVO.swift
//  MyKkumi
//
//  Created by 최재혁 on 7/2/24.
//

import Foundation

public struct PostsVO: Codable {
    let posts: [PostVO]
    let cursor: String
    
    enum CodingKeys: String, CodingKey {
        case posts
        case cursor
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        posts = try values.decodeIfPresent([PostVO].self, forKey: .posts)!
        cursor = try values.decodeIfPresent(String.self, forKey: .cursor)!
    }
}

public struct PostVO: Codable {
    let id: Int
    let imageURLs: [String]
    let category: String
    let subCategory: String
    let writer: Writer
    let content: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case imageURLs = "images"
        case category
        case subCategory
        case writer
        case content
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)!
        imageURLs = try values.decodeIfPresent([String].self, forKey: .imageURLs)!
        category = try values.decodeIfPresent(String.self, forKey: .category)!
        subCategory = try values.decodeIfPresent(String.self, forKey: .subCategory)!
        writer = try values.decodeIfPresent(Writer.self, forKey: .writer)!
        content = try values.decodeIfPresent(String.self, forKey: .content)!
    }
}

public struct Writer: Codable {
    let profileImage: String
    let nickname: String
    
    enum CodingKeys: String, CodingKey {
        case profileImage
        case nickname
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        profileImage = try values.decodeIfPresent(String.self, forKey: .profileImage)!
        nickname = try values.decodeIfPresent(String.self, forKey: .nickname)!
    }
}
