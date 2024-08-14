//
//  Typograpy.swift
//  MyKkumi
//
//  Created by 최재혁 on 8/13/24.
//

import UIKit

import UIKit

enum Typography {
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
    case chap
    case gmarketSansBold
    
    var attributes: [NSAttributedString.Key: Any] {
           let paragraphStyle = NSMutableParagraphStyle()
           switch self {
           case .heading22Bold:
               paragraphStyle.minimumLineHeight = 22*1.4
               paragraphStyle.maximumLineHeight = 22*1.4
           case .heading20Bold:
               paragraphStyle.minimumLineHeight = 20*1.4
               paragraphStyle.maximumLineHeight = 20*1.4
           case .heading18Bold :
               paragraphStyle.minimumLineHeight = 18*1.4
               paragraphStyle.maximumLineHeight = 18*1.4
           case .heading18SemiBold :
               paragraphStyle.minimumLineHeight = 18*1.4
               paragraphStyle.maximumLineHeight = 18*1.4
           case .gmarketSansBold :
               paragraphStyle.minimumLineHeight = 18*1.4
               paragraphStyle.maximumLineHeight = 18*1.4
           case .subTitle16Bold :
               paragraphStyle.minimumLineHeight = 16*1.4
               paragraphStyle.maximumLineHeight = 16*1.4
           case .subTitle16Medium :
               paragraphStyle.minimumLineHeight = 16*1.4
               paragraphStyle.maximumLineHeight = 16*1.4
           case .body15SemiBold:
               paragraphStyle.minimumLineHeight = 15*1.4
               paragraphStyle.maximumLineHeight = 15*1.4
           case .body15Medium:
               paragraphStyle.minimumLineHeight = 15*1.4
               paragraphStyle.maximumLineHeight = 15*1.4
           case .body15Regular:
               paragraphStyle.minimumLineHeight = 15*1.4
               paragraphStyle.maximumLineHeight = 15*1.4
           case .body14SemiBold:
               paragraphStyle.minimumLineHeight = 14*1.4
               paragraphStyle.maximumLineHeight = 14*1.4
           case .body14Medium:
               paragraphStyle.minimumLineHeight = 14*1.4
               paragraphStyle.maximumLineHeight = 14*1.4
           case .body14Regular:
               paragraphStyle.minimumLineHeight = 14*1.4
               paragraphStyle.maximumLineHeight = 14*1.4
           case .body13SemiBold:
               paragraphStyle.minimumLineHeight = 13*1.4
               paragraphStyle.maximumLineHeight = 13*1.4
           case .body13Medium:
               paragraphStyle.minimumLineHeight = 13*1.4
               paragraphStyle.maximumLineHeight = 13*1.4
           case .caption12Medium:
               paragraphStyle.minimumLineHeight = 12*1.4
               paragraphStyle.maximumLineHeight = 12*1.4
           case .caption11Medium:
               paragraphStyle.minimumLineHeight = 11*1.4
               paragraphStyle.maximumLineHeight = 11*1.4
           case .chap :
               paragraphStyle.minimumLineHeight = 24*1.4
               paragraphStyle.maximumLineHeight = 24*1.4
           }

           return [
               .font: self.font(),
               .paragraphStyle: paragraphStyle
           ]
       }

    func font() -> UIFont {
        switch self {
        case .heading22Bold:
            return UIFont(name: "Pretendard-Bold", size: 22)!
        case .heading20Bold:
            return UIFont(name: "Pretendard-Bold", size: 20)!
        case .heading18Bold:
            return UIFont(name: "Pretendard-Bold", size: 18)!
        case .heading18SemiBold:
            return UIFont(name: "Pretendard-SemiBold", size: 18)!
        case .subTitle16Bold:
            return UIFont(name: "Pretendard-Bold", size: 16)!
        case .subTitle16Medium:
            return UIFont(name: "Pretendard-Medium", size: 16)!
        case .body15SemiBold:
            return UIFont(name: "Pretendard-SemiBold", size: 15)!
        case .body15Medium:
            return UIFont(name: "Pretendard-Medium", size: 15)!
        case .body15Regular:
            return UIFont(name: "Pretendard-Regular", size: 15)!
        case .body14SemiBold:
            return UIFont(name: "Pretendard-SemiBold", size: 14)!
        case .body14Medium:
            return UIFont(name: "Pretendard-Medium", size: 14)!
        case .body14Regular:
            return UIFont(name: "Pretendard-Regular", size: 14)!
        case .body13SemiBold:
            return UIFont(name: "Pretendard-SemiBold", size: 13)!
        case .body13Medium:
            return UIFont(name: "Pretendard-Medium", size: 13)!
        case .caption12Medium:
            return UIFont(name: "Pretendard-Medium", size: 12)!
        case .caption11Medium:
            return UIFont(name: "Pretendard-Medium", size: 11)!
        case .chap :
            return UIFont(name : "chap", size: 24)!
        case .gmarketSansBold :
            return UIFont(name : "GmarketSansBold", size: 18)!
        }
    }
}

