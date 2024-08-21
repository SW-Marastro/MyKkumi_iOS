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
        posts = try values.decode([PostVO].self, forKey: .posts)
        cursor = try values.decode(String.self, forKey: .cursor)
    }
}

public struct PostVO: Codable {
    let id: Int
    let category: String
    let subCategory: String
    let writer: Writer
    let content: [ContentVO]
    let images : [Image]
    
    enum CodingKeys: String, CodingKey {
        case id
        case images
        case category
        case subCategory
        case writer
        case content
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        images = try values.decode([Image].self, forKey: .images)
        category = try values.decode(String.self, forKey: .category)
        subCategory = try values.decode(String.self, forKey: .subCategory)
        writer = try values.decode(Writer.self, forKey: .writer)
        content = try values.decode([ContentVO].self, forKey: .content)
    }
}

struct ContentVO: Codable {
    let type: ContentType
    let text: String
    let color: String?
    let linkUrl: String?
    
    enum CodingKeys : String, CodingKey {
        case type
        case text
        case color
        case linkUrl
    }
    
    public init(from decoder : Decoder) throws {
        let value = try decoder.container(keyedBy: CodingKeys.self)
        type = try value.decode(ContentType.self, forKey: .type)
        text = try value.decode(String.self, forKey: .text)
        color = try value.decodeIfPresent(String.self, forKey: .color)
        linkUrl = try value.decodeIfPresent(String.self, forKey: .linkUrl)
    }
}

public struct Writer: Codable {
    let profileImage: String?
    let nickname: String
    let uuid : String
    
    enum CodingKeys: String, CodingKey {
        case profileImage
        case nickname
        case uuid
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        profileImage = try values.decodeIfPresent(String.self, forKey: .profileImage) ?? "nullValue"
        nickname = try values.decode(String.self, forKey: .nickname)
        uuid = try values.decode(String.self, forKey: .uuid)
    }
}

enum ContentType: String, Codable {
    case plain
    case hashtag
}

public struct ReportBody : Codable {
    let postId : Int
    let reason : String
    let content : String
    
    public init(postId: Int, reason: String, content: String) {
        self.postId = postId
        self.reason = reason
        self.content = content
    }
}

public struct ReportResult : Codable {
    let result : String
    
    enum CodingKeys : String, CodingKey {
        case result
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.result = try container.decode(String.self, forKey: .result)
    }
}
