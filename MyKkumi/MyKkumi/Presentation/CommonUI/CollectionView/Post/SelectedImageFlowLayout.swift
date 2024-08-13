//
//  PostImageCollectionViewFlowLayout.swift
//  MyKkumi
//
//  Created by 최재혁 on 7/2/24.
//

import UIKit

open class SelectedImageFlowLayout : UICollectionViewFlowLayout {
    public override init() {
        super.init()
        initAttribute()
    }
    
    private func initAttribute() {
        scrollDirection = .horizontal
        minimumLineSpacing = 5
        minimumInteritemSpacing = 5
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
