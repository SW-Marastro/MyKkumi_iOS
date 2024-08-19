//
//  UILabelExtention+RichText.swift
//  MyKkumi
//
//  Created by 최재혁 on 8/15/24.
//

import Foundation
import UIKit

extension UILabel {
    func setTextWithMore(content: [ContentVO]) {
        let richText = createRichText(from: content)
        let maxLength = CountValues.MaxPostContentCount.value
        
        if richText.length > maxLength {
            let truncatedText = richText.attributedSubstring(from: NSRange(location: 0, length: maxLength))
            var attributes = Typography.body14SemiBold(color: AppColor.neutral900).attributes
            attributes[.link] = "moreTapped"
            let moreText = NSAttributedString(string: "...더보기", attributes: attributes)
            
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
        
        if let content = currentText.string.split(separator: " ").map({ String($0) }) as? [ContentVO] {
            let fullText = createRichText(from: content)
            self.attributedText = fullText
        }
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
            var attributeDict: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor(hex: item.color ?? "#000000")
            ]
            
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
