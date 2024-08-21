//
//  MultiLineTagView.swift
//  MyKkumi
//
//  Created by 최재혁 on 8/21/24.
//

import Foundation
import UIKit

class MultiLineTagView: UIView {
    private let horizontalSpacing: CGFloat
    private let verticalSpacing: CGFloat
    private let rowHeight: CGFloat
    private var intrinsicHeight: CGFloat = 0
    private let horizontalPadding: CGFloat
    
    private var buttons: [UIButton] = []
    
    init(
        horizontalSpacing: CGFloat = 0,
        verticalSpacing: CGFloat = 0,
        rowHeight: CGFloat,
        horizontalPadding: CGFloat = 0
    ) {
        self.horizontalSpacing = horizontalSpacing
        self.verticalSpacing = verticalSpacing
        self.rowHeight = rowHeight
        self.horizontalPadding = horizontalPadding
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 상속해서 사용할 label의 속성을 지정해줍니다
    func applyAttribute(button: UIButton) {
        button.layer.borderWidth = 1
        button.layer.borderColor = AppColor.neutral200.color.cgColor
        button.backgroundColor = AppColor.white.color
        button.layer.cornerRadius = 16.5
    }
    
    final func setTag(words: [String], id : [Int]) {
        var count = 0
        for word in words {
            let button = UIButton()
            button.setAttributedTitle(NSAttributedString(string: word, attributes: Typography.body14Medium(color: AppColor.neutral700).attributes), for: .normal)
            applyAttribute(button: button)
            addSubview(button)
            button.frame.size.width = button.intrinsicContentSize.width + horizontalPadding * 2
            button.frame.size.height = rowHeight
            button.tag = id[count]
            buttons.append(button)
            count += 1
        }
    }
    
    final private func setupLayout() {
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        
        self.buttons.forEach { button in
            if currentX + button.frame.width > bounds.width {
                // 다음행으로 이동
                currentX = 0
                currentY += rowHeight + verticalSpacing
            }
            button.frame.origin = CGPoint(x: currentX, y: currentY)
            currentX += button.frame.width + horizontalSpacing
        }
        intrinsicHeight = currentY + rowHeight
        invalidateIntrinsicContentSize()
    }
    
    final func getButtons() -> [UIButton] {
        return self.buttons
    }
    
    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        size.height = intrinsicHeight
        return size
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayout()
    }
}
