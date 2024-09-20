//
//  ErrorVO.swift
//  MyKkumi
//
//  Created by 최재혁 on 6/27/24.
//
//DTO -> backend에서 온 순수한 Data
//VO -> repository에서 DTO를 앱에서 사용하는 데이터 VO로 변경해서 보내줘야함. 해당 개념 바탕으로 DTO, VO 다시 구분이 필요할듯
import Foundation

public struct ErrorVO : Codable {
    let errorCode : String
    let message : String
    let detail : String
    
    enum CodingKeys : String, CodingKey {
        case errorCode
        case message
        case detail
    }
    
    public init(errorCode: String, message: String, detail: String) {
        self.errorCode = errorCode
        self.message = message
        self.detail = detail
    }

    public init(from decoder : Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        errorCode = try values.decode(String.self, forKey: .errorCode)
        message = try values.decode(String.self, forKey: .message)
        detail = try values.decode(String.self, forKey: .detail)
    }
}
