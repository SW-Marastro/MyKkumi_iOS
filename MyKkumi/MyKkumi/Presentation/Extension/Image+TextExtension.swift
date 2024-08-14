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
    func load(url: URL, placeholder: String, completion: ((UIImage?) -> Void)? = nil) {
        // 플레이스홀더 이미지를 설정
        self.image = UIImage(named: placeholder)
        
        DispatchQueue.global().async { [weak self] in
            var loadedImage: UIImage? = nil
            
            // URL에서 데이터를 로드하고 이미지로 변환
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                loadedImage = image
                
                DispatchQueue.main.async {
                    self?.image = image
                }
            }
            
            // Main Queue에서 completion handler 호출
            DispatchQueue.main.async {
                completion?(loadedImage)
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

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        let r = CGFloat((rgbValue & 0xff0000) >> 16) / 255.0
        let g = CGFloat((rgbValue & 0xff00) >> 8) / 255.0
        let b = CGFloat(rgbValue & 0xff) / 255.0
        self.init(red: r, green: g, blue: b, alpha: alpha)
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

extension UIButton {
    var uuidString: String? {
        get {
            return objc_getAssociatedObject(self, &uuidKey) as? String
        }
        set {
            objc_setAssociatedObject(self, &uuidKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
