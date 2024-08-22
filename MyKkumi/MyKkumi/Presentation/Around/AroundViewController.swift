//
//  AroundViewController.swift
//  MyKkumi
//
//  Created by 최재혁 on 6/25/24.
//

import Foundation
import RxSwift

class AroundViewController : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(label)
        view.backgroundColor = AppColor.white.color
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private let label : UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "서비스 준비중입니다🔥", attributes: Typography.heading18Bold(color: AppColor.black).attributes)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
}
