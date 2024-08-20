//
//  CustomTabBarController.swift
//  MyKkumi
//
//  Created by 최재혁 on 8/19/24.
//

import Foundation
import UIKit

class CustomTabBarController: UITabBarController {

    let addPinButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.barTintColor = .white
        tabBar.backgroundColor = .white

        // Remove default shadow and add custom shadow
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -3)
        tabBar.layer.shadowRadius = 10
        tabBar.layer.shadowOpacity = 0.1
        tabBar.layer.masksToBounds = false
        tabBar.isTranslucent = false
        
        //addpinButton
//        addPinButton.frame.size = CGSize(width: 24, height: 24)
//        var middleButtonFrame = addPinButton.frame
//        middleButtonFrame.origin.y = tabBar.bounds.height/2
//        middleButtonFrame.origin.x = tabBar.bounds.width / 2 - middleButtonFrame.size.width / 2
//        addPinButton.frame = middleButtonFrame
//        addPinButton.setBackgroundImage(AppImage.addPostButton.image, for: .normal)
//        
//        tabBar.addSubview(addPinButton)
//        tabBar.bringSubviewToFront(addPinButton)
    }
    
    public func setupLayout() {
        for item in tabBar.items! {
            item.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        }
    }
}
