//
//  PostImageCollectionView.swift
//  MyKkumi
//
//  Created by 최재혁 on 7/2/24.
//

import UIKit

open class PostImageCollectionView : UICollectionView {
    
    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        initAttribute()
    }
    
    private func initAttribute() {
        self.backgroundColor = Colors.GrayColor
        self.layer.masksToBounds = false
        self.register(PostImageCollectionViewCell.self, forCellWithReuseIdentifier: PostImageCollectionViewCell.cellID)
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.isPagingEnabled = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

