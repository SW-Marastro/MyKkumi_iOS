//
//  BannerCollectionCell.swift
//  MyKkumi
//
//  Created by 최재혁 on 6/26/24.
//

import UIKit

open class BannerCollectionCell : UICollectionViewCell {
    public static let cellID = "BannerCollectionCell"
    let imageView : UIImageView = UIImageView(frame: .zero)
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initAttribute()
        initUI()
    }
    
    private func initAttribute() {
        self.layer.cornerRadius = 10
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
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
