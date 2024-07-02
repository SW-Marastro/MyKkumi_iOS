//
//  PostImageCollectionViewFlowLayout.swift
//  MyKkumi
//
//  Created by 최재혁 on 7/2/24.
//

import UIKit

open class PostImageCollectionViewFlowLayout : UICollectionViewFlowLayout {
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
