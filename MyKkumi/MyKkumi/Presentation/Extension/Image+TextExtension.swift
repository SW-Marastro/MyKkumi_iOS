//
//  ImageExtention.swift
//  MyKkumi
//
//  Created by 최재혁 on 6/27/24.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

private var uuidKey: UInt8 = 0

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
    
    var uuidString: String? {
        get {
            return objc_getAssociatedObject(self, &uuidKey) as? String
        }
        set {
            objc_setAssociatedObject(self, &uuidKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

extension UIImage {
    func resized(toMaxSize maxSize: CGSize) -> UIImage {
        // 이미지의 원본 크기
        let originalSize = self.size
        
        // 원본 이미지가 이미 최대 크기보다 작으면 그대로 반환
        if originalSize.width <= maxSize.width && originalSize.height <= maxSize.height {
            return self
        }
        
        // 최대 크기에 맞춰 비율을 유지하면서 리사이즈할 크기를 계산
        let aspectWidth = maxSize.width / originalSize.width
        let aspectHeight = maxSize.height / originalSize.height
        let aspectRatio = min(aspectWidth, aspectHeight)
        
        let newSize = CGSize(width: originalSize.width * aspectRatio, height: originalSize.height * aspectRatio)
        
        // UIGraphicsImageRenderer를 사용하여 이미지를 리사이즈
        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}

extension Reactive where Base: UIImageView {
    public var tapGesture: ControlEvent<UITapGestureRecognizer> {
        let gesture = UITapGestureRecognizer()
        base.addGestureRecognizer(gesture)
        base.isUserInteractionEnabled = true
        return ControlEvent(events: gesture.rx.event)
    }
}

extension UITextField {
    func underline(viewSize : CGFloat, color : UIColor) {
        let border  = CALayer()
        border.borderColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height + 10 , width: self.frame.width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
}
