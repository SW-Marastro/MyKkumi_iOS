//
//  AppValues.swift
//  MyKkumi
//
//  Created by 최재혁 on 8/8/24.
//

import Foundation

enum CountValues {
    case MaxImageCount
    case MaxMakePostContentCount
    case MaxHashTagCount
    case MaxPinCount
    case MaxPostContentCount
}

extension CountValues {
    var value : Int {
        switch self {
        case .MaxImageCount :
            return 10
        case .MaxMakePostContentCount :
            return 2000
        case .MaxHashTagCount : 
            return 20
        case .MaxPinCount :
            return 10
        case .MaxPostContentCount :
            return 50
        }
    }
}
