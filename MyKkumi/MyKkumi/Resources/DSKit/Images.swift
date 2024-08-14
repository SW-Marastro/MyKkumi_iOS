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
        }
    }
}
