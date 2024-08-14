//
//  Images.swift
//  MyKkumi
//
//  Created by 최재혁 on 8/13/24.
//

import UIKit

enum AppImage {
    case appLogo
    case launch
    case kakaoSimbol
    case profile
    case ellipse
    case cancel
    case homeUnselected
    case homeSelected
    case browseUnselected
    case browseSelected
    case addPostButton
    case shoppingUnselected
    case shoppingSelected
    case mypageUnselected
    case mypageSelected
    
    var image : UIImage {
        return self.getImage()
    }
    
    func getImage() -> UIImage {
        switch self {
        case.appLogo :
            return UIImage(named: "AppLogo")!
        case .launch :
            return UIImage(named : "Launch")!
        case .kakaoSimbol :
            return UIImage(named : "KakaoSimbol")!
        case .profile :
            return UIImage(named : "ProfilePlaceHold")!
        case .ellipse :
            return UIImage(named: "Ellipse")!
        case .cancel :
            return UIImage(named : "CancelButton")!
        case .homeUnselected :
            return UIImage(named : "HomeUnselected")!
        case .homeSelected :
            return UIImage(named : "HomeSelected")!
        case .browseUnselected :
            return UIImage(named : "BrowseUnselected")!
        case .browseSelected :
            return UIImage(named : "BrowseSelected")!
        case .addPostButton :
            return UIImage(named : "AddPostButton")!
        case .shoppingUnselected :
            return UIImage(named : "ShoppingUnselected")!
        case .shoppingSelected :
            return UIImage(named : "ShoppingSelected")!
        case .mypageUnselected :
            return UIImage(named : "MypageUnselected")!
        case .mypageSelected :
            return UIImage(named : "MypageSelected")!
            
        }
    }
}
