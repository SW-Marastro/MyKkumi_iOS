//
//  Typograpy.swift
//  MyKkumi
//
//  Created by 최재혁 on 8/13/24.
//

import UIKit

enum Typography {
    case heading22Bold(color: AppColor)
    case heading20Bold(color: AppColor)
    case heading18Bold(color: AppColor)
    case heading18SemiBold(color: AppColor)
    case subTitle16Bold(color: AppColor)
    case subTitle16Medium(color: AppColor)
    case body15SemiBold(color: AppColor)
    case body15Medium(color: AppColor)
    case body15Regular(color: AppColor)
    case body14SemiBold(color: AppColor)
    case body14Medium(color: AppColor)
    case body14Regular(color: AppColor)
    case body13SemiBold(color: AppColor)
    case body13Medium(color: AppColor)
    case caption12Medium(color: AppColor)
    case caption11Medium(color: AppColor)
    case chab(color: AppColor)
    case gmarketSansBold(color: AppColor)
    
    var attributes: [NSAttributedString.Key: Any] {
        let paragraphStyle = NSMutableParagraphStyle()
        
        // 색상을 가져오기 위해 AppColor 사용
        let textColor: UIColor
        
        switch self {
        case .heading22Bold(let color),
             .heading20Bold(let color),
             .heading18Bold(let color),
             .heading18SemiBold(let color),
             .subTitle16Bold(let color),
             .subTitle16Medium(let color),
             .body15SemiBold(let color),
             .body15Medium(let color),
             .body15Regular(let color),
             .body14SemiBold(let color),
             .body14Medium(let color),
             .body14Regular(let color),
             .body13SemiBold(let color),
             .body13Medium(let color),
             .caption12Medium(let color),
             .caption11Medium(let color),
             .chab(let color),
             .gmarketSansBold(let color):
            textColor = color.color
            
            // lineHeight 설정
            paragraphStyle.minimumLineHeight = self.lineHeight()
            paragraphStyle.maximumLineHeight = self.lineHeight()
        }

        return [
            .font: self.font(),
            .foregroundColor: textColor,  // 설정한 색상을 사용
            .paragraphStyle: paragraphStyle,
            .baselineOffset : (self.lineHeight() - self.font().lineHeight) / 4
        ]
    }
    
    func lineHeight() -> CGFloat {
        switch self {
        case .heading22Bold: return 22 * 1.4
        case .heading20Bold: return 20 * 1.4
        case .heading18Bold: return 18 * 1.4
        case .heading18SemiBold: return 18 * 1.4
        case .subTitle16Bold: return 16 * 1.4
        case .subTitle16Medium: return 16 * 1.4
        case .body15SemiBold: return 15 * 1.4
        case .body15Medium: return 15 * 1.4
        case .body15Regular: return 15 * 1.4
        case .body14SemiBold: return 14 * 1.4
        case .body14Medium: return 14 * 1.4
        case .body14Regular: return 14 * 1.4
        case .body13SemiBold: return 13 * 1.4
        case .body13Medium: return 13 * 1.4
        case .caption12Medium: return 12 * 1.4
        case .caption11Medium: return 11 * 1.4
        case .chab: return 24 * 1.4
        case .gmarketSansBold: return 18 * 1.4
        }
    }

    func font() -> UIFont {
        switch self {
        case .heading22Bold: return UIFont(name: "Pretendard-Bold", size: 22)!
        case .heading20Bold: return UIFont(name: "Pretendard-Bold", size: 20)!
        case .heading18Bold: return UIFont(name: "Pretendard-Bold", size: 18)!
        case .heading18SemiBold: return UIFont(name: "Pretendard-SemiBold", size: 18)!
        case .subTitle16Bold: return UIFont(name: "Pretendard-Bold", size: 16)!
        case .subTitle16Medium: return UIFont(name: "Pretendard-Medium", size: 16)!
        case .body15SemiBold: return UIFont(name: "Pretendard-SemiBold", size: 15)!
        case .body15Medium: return UIFont(name: "Pretendard-Medium", size: 15)!
        case .body15Regular: return UIFont(name: "Pretendard-Regular", size: 15)!
        case .body14SemiBold: return UIFont(name: "Pretendard-SemiBold", size: 14)!
        case .body14Medium: return UIFont(name: "Pretendard-Medium", size: 14)!
        case .body14Regular: return UIFont(name: "Pretendard-Regular", size: 14)!
        case .body13SemiBold: return UIFont(name: "Pretendard-SemiBold", size: 13)!
        case .body13Medium: return UIFont(name: "Pretendard-Medium", size: 13)!
        case .caption12Medium: return UIFont(name: "Pretendard-Medium", size: 12)!
        case .caption11Medium: return UIFont(name: "Pretendard-Medium", size: 11)!
        case .chab: return UIFont(name: "LOTTERIACHAB", size: 20)!
        case .gmarketSansBold: return UIFont(name: "GmarketSansBold", size: 18)!
        }
    }
}
