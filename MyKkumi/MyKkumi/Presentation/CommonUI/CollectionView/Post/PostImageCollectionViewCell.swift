//
//  PostImageCollectionViewCell.swift
//  MyKkumi
//
//  Created by 최재혁 on 7/2/24.
//

import UIKit

open class PostImageCollectionViewCell : UICollectionViewCell {
    public static let cellID = "PostImageCollectionViewCell"
    var imageView : UIImageView = UIImageView(frame: .zero)
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initAttribute()
        initUI()
    }
    
    private func initAttribute() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
    
    private func initUI() {
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
