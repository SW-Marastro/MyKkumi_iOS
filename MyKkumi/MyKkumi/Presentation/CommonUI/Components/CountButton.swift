//
//  CountButton.swift
//  MyKkumi
//
//  Created by 최재혁 on 7/5/24.
//

import UIKit

class CountButton : UIView {
    
    public init(image : String, text : String) {
        super.init(frame: .zero)
        button.setBackgroundImage(UIImage(named : image), for: .normal)
        label.text = text
        label.font = UIFont.systemFont(ofSize: 14)
        setupLayout()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        self.addSubview(mainStack)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        [button, label].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            mainStack.addArrangedSubview($0)
        }
        
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: self.topAnchor),
            mainStack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            mainStack.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalTo: label.heightAnchor),
            button.heightAnchor.constraint(equalTo: button.widthAnchor)
        ])
    }
    
    let mainStack : UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .leading
        view.spacing = 2
        return view
    }()
    
    let button : UIButton = {
        let button = UIButton()
        return button
    }()
    
    let label : UILabel = {
        let label = UILabel()
        return label
    }()
}
