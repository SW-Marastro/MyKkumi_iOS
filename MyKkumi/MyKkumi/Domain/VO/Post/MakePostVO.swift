//
//  WritePostVO.swift
//  MyKkumi
//
//  Created by 최재혁 on 8/6/24.
//

import Foundation

public struct MakePostVO : Codable {
    let subCategoryId : Int
    var content : String?
    var images : [Image]
}

public struct Image : Codable {
    let url : String
    var pins : [Pin]
}

public struct Pin : Codable {
    var positionX : Double
    var positionY : Double
    var productInfo : ProductInfo?
    
    public init(positionX: Double, positionY: Double, productInfo: ProductInfo? = nil) {
        self.positionX = positionX
        self.positionY = positionY
        self.productInfo = productInfo
    }
}

public struct ProductInfo : Codable {
    var name : String
    var url : String
}

public struct MakePostResponse : Codable {
    let postId : Int
    
    enum CodingKeys : String, CodingKey {
        case postId
    }
    
    public init(from decoder : Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        postId =  try values.decode(Int.self , forKey: .postId)
    }
}

public struct PreSignedUrlVO : Codable {
    let url : String
    
    enum CodingKeys : String, CodingKey {
        case url
    }
    
    public init(from decoder : Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        url = try values.decode(String.self, forKey: .url)
    }
}
