//
//  AppValues.swift
//  MyKkumi
//
//  Created by 최재혁 on 8/8/24.
//

import Foundation

enum CountValues {
    case MaxImageCount
    case MaxContentCount
    case MaxHashTagCount
}

extension CountValues {
    var value : Int {
        switch self {
        case .MaxImageCount :
            return 10
        case .MaxContentCount :
            return 2000
        case .MaxHashTagCount : 
            return 20
        }
    }
}
