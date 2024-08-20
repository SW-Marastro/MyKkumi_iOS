//
//  UILabelExtention+RichText.swift
//  MyKkumi
//
//  Created by 최재혁 on 8/15/24.
//

import Foundation
import UIKit

private var originalContentKey : UInt8 = 0

extension UILabel {
    
    var originalContent: [ContentVO]? {
        get {
            return objc_getAssociatedObject(self, &originalContentKey) as? [ContentVO]
        }
        set {
            objc_setAssociatedObject(self, &originalContentKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func setTextWithMore(content: [ContentVO]) {
        let richText = createRichText(from: content)
        self.originalContent = content

        if richText.length > CountValues.MaxPostContentCount.value {
            let truncatedText = richText.attributedSubstring(from: NSRange(location: 0, length: CountValues.MaxPostContentCount.value))
            let font = Typography.body14SemiBold(color: AppColor.neutral900).font()
            let moreAttributes: [NSAttributedString.Key: Any] = [
                .link: "moreTapped",
                .foregroundColor: AppColor.neutral900.color,
                .font: font
            ]
            let moreText = NSAttributedString(string: "...더보기", attributes: moreAttributes)
            
            let combinedText = NSMutableAttributedString()
            combinedText.append(truncatedText)
            combinedText.append(moreText)
            
            self.attributedText = combinedText
            self.isUserInteractionEnabled = true
            self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleTapOnMore)))
        } else {
            self.attributedText = richText
        }
    }

    @objc private func handleTapOnMore() {
        guard let currentText = self.attributedText else { return }
        
        let fullText = createRichText(from: originalContent ?? [])
        self.attributedText = fullText
    }
}

func createRichText(from content: [ContentVO]) -> NSAttributedString {
    let attributedString = NSMutableAttributedString()

    for item in content {
        let attributes: [NSAttributedString.Key: Any]
        let font = Typography.body14Regular(color: AppColor.neutral900).font()
        
        switch item.type {
        case .plain:
            // 기본 텍스트 속성
            attributes = [.font: font]
            
        case .hashtag:
            // 해시태그 속성
            var attributeDict: [NSAttributedString.Key: Any] = [:]

            if let color = item.color {
                attributeDict[.foregroundColor] = AppColor.hash.color
            }

            if let link = item.linkUrl, let url = URL(string: link) {
                attributeDict[.link] = url
            }
            
            attributeDict[.font] = font
            
            attributes = attributeDict
        }

        let attributedText = NSAttributedString(string: item.text, attributes: attributes)
        attributedString.append(attributedText)
    }

    return attributedString
}
