//
//  LogEvent.swift
//  MyKkumi
//
//  Created by 최재혁 on 11/6/24.
//

import Foundation

public enum LogEvnetParameter {
    case HomeViewController
    case BannerInfoViewController
    case DetailBannerViewController
    case AuthViewController
    case CollectCategoryViewController
    case MakeProfileViewController
    case MakePostViewController
    case PinInfoViewController
    case MypageViewController
}

extension LogEvnetParameter {
    var value : String {
        switch self {
        case .HomeViewController:
            return "HomeViewController"
        case .BannerInfoViewController:
            return "BannerAllScreen"
        case .DetailBannerViewController:
            return "BannerDetailScreen"
        case .AuthViewController :
            return "LoginScreen"
        case .CollectCategoryViewController :
            return "SelectCategoryScreen"
        case .MakeProfileViewController :
            return "InputUserInfoScreen"
        case .MakePostViewController :
            return "EditPostScreen"
        case .PinInfoViewController :
            return "InputProductScreen"
        case .MypageViewController :
            return "MypageScreen"
        }
    }
}

