//
//  Typograpy.swift
//  MyKkumi
//
//  Created by 최재혁 on 8/13/24.
//

import UIKit

import UIKit

public enum Typography {
    case heading22Bold
    case heading20Bold
    case heading18Bold
    case heading18SemiBold
    case subTitle16Bold
    case subTitle16Medium
    case body15SemiBold
    case body15Medium
    case body15Regular
    case body14SemiBold
    case body14Medium
    case body14Regular
    case body13SemiBold
    case body13Medium
    case caption12Medium
    case caption11Medium

    func font() -> UIFont {
        switch self {
        case .heading22Bold:
            return UIFont(name: "Pretenard-Bold", size: 22)!
        case .heading20Bold:
            return UIFont(name: "Pretenard-Bold", size: 20)!
        case .heading18Bold:
            return UIFont(name: "Pretenard-Bold", size: 18)!
        case .heading18SemiBold:
            return UIFont(name: "Pretenard-SemiBold", size: 18)!
        case .subTitle16Bold:
            return UIFont(name: "Pretenard-Bold", size: 16)!
        case .subTitle16Medium:
            return UIFont(name: "Pretenard-Medium", size: 16)!
        case .body15SemiBold:
            return UIFont(name: "Pretenard-SemiBold", size: 15)!
        case .body15Medium:
            return UIFont(name: "Pretenard-Medium", size: 15)!
        case .body15Regular:
            return UIFont(name: "Pretenard-Regular", size: 15)!
        case .body14SemiBold:
            return UIFont(name: "Pretenard-SemiBold", size: 14)!
        case .body14Medium:
            return UIFont(name: "Pretenard-Medium", size: 14)!
        case .body14Regular:
            return UIFont(name: "Pretenard-Regular", size: 14)!
        case .body13SemiBold:
            return UIFont(name: "Pretenard-SemiBold", size: 13)!
        case .body13Medium:
            return UIFont(name: "Pretenard-Medium", size: 13)!
        case .caption12Medium:
            return UIFont(name: "Pretenard-Medium", size: 12)!
        case .caption11Medium:
            return UIFont(name: "Pretenard-Medium", size: 11)!
        }
    }
}

