//
//  ImageExtention.swift
//  MyKkumi
//
//  Created by 최재혁 on 6/27/24.
//

import Foundation
import UIKit

extension UIImageView {
    func load(url: URL, placeholder : String) {
        self.image = UIImage(named: placeholder)
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

extension UITextField {
    func underline(viewSize : CGFloat, color : UIColor) {
        let border  = CALayer()
        let widt = CGFloat(1)
        border.borderColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height + 10 , width: self.frame.width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
}
