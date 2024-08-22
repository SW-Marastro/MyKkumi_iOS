//
//  CategoryCollectionView.swift
//  MyKkumi
//
//  Created by 최재혁 on 7/22/24.
//

import UIKit

open class CategoryCollectionView : UICollectionView {
    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        initAttribute()
    }
    
    private func initAttribute() {
        self.layer.masksToBounds = false
        self.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.cellID)
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.isPagingEnabled = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
