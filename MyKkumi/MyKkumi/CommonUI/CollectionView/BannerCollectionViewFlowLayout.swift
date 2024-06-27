//
//  BannerCollectionViewFlowLayout.swift
//  MyKkumi
//
//  Created by 최재혁 on 6/26/24.
//

import UIKit

open class BannerCollectionViewFlowLayout : UICollectionViewFlowLayout {
    public override init() {
        super.init()
        initAttribute()
    }
    
    private func initAttribute() {
        scrollDirection = .horizontal
        minimumLineSpacing = 0;
        minimumInteritemSpacing = 0
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
