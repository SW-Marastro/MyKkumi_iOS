//
//  File.swift
//  MyKkumi
//
//  Created by 최재혁 on 6/17/24.
//

import Foundation

public struct HelloWorld : Codable {
    let title : String?
    
    enum CodingKeys : String, CodingKey {
        case title
    }
    
    public init(from decoder : Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decodeIfPresent(String.self, forKey: .title)
    }
}
