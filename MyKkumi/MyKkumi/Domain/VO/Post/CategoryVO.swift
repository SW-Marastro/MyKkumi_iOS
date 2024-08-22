//
//  CategoryVO.swift
//  MyKkumi
//
//  Created by 최재혁 on 8/8/24.
//

import Foundation

public struct CategoriesVO : Codable {
    let categories : [CategoryVO]
    
    enum CodingKeys : String, CodingKey {
        case categories
    }
    
    public init(from decoder :Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        categories = try values.decode([CategoryVO].self, forKey: .categories)
    }
}

public struct CategoryVO : Codable {
    let id : UInt64
    let name : String
    let subCategories : [SubCategoriesVO]
 
    enum CodingKeys : String, CodingKey {
        case id
        case name
        case subCategories
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(UInt64.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        subCategories = try values.decode([SubCategoriesVO].self, forKey: .subCategories)
    }
}

public struct SubCategoriesVO : Codable {
    let id : UInt64
    let name : String
    
    enum CodingKeys : String, CodingKey {
        case id
        case name
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(UInt64.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
    }
}
