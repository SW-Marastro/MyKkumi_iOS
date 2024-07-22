//
//  CategoryCollectionViewCell.swift
//  MyKkumi
//
//  Created by 최재혁 on 7/22/24.
//

import UIKit

open class CategoryCollectionViewCell : UICollectionViewCell {
    public static let cellID = "CategoryCollectionViewCell"
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    public func initAttribute() {
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
    }
    
    private func initUI() {
        contentView.addSubview(mainStack)
        mainStack.addSubview(label)
        mainStack.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: label.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: label.widthAnchor),
            imageView.topAnchor.constraint(equalTo: mainStack.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.bottomAnchor.constraint(equalTo: mainStack.bottomAnchor)
        ])
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var mainStack : UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 3
        return stack
    }()
    
    var imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "heart")
        return imageView
    }()
    
    var label : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
}
