//
//  BannerCollectinoView.swift
//  MyKkumi
//
//  Created by 최재혁 on 6/26/24.
//

import UIKit

open class BannerCollectionView : UICollectionView {
    
    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        initAttribute()
    }
    
    private func initAttribute() {
        self.backgroundColor = Colors.GrayColor
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 10
        self.register(BannerCollectionCell.self, forCellWithReuseIdentifier: BannerCollectionCell.cellID)
        self.register(BannerCollectionCellVertical.self, forCellWithReuseIdentifier: BannerCollectionCellVertical.cellID)
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.isPagingEnabled = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
