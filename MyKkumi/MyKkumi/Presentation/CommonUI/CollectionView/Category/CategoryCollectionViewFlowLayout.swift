//
//  CategoryCollectionViewFlowLayout.swift
//  MyKkumi
//
//  Created by 최재혁 on 7/22/24.
//

import UIKit

open class CategoryCollectionViewFlowLayout : UICollectionViewFlowLayout {
    public override init() {
        super.init()
        initAttribute()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initAttribute() {
        scrollDirection = .horizontal
        minimumLineSpacing = 0;
        minimumInteritemSpacing = 10
    }
}
