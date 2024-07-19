//
//  PostTableView.swift
//  MyKkumi
//
//  Created by 최재혁 on 7/2/24.
//

import UIKit

open class PostTableView: UITableView {
    public override init(frame : CGRect, style : UITableView.Style) {
        super.init(frame: frame, style: style)
        initAtrribute()
    }
    
    func initAtrribute() {
        self.register(PostTableCell.self, forCellReuseIdentifier: PostTableCell.cellID)
        self.register(HomeBannerCell.self, forCellReuseIdentifier: HomeBannerCell.cellID)
        self.rowHeight = 350
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required public init?(coder : NSCoder) {
        fatalError("init(coder : ) has not been implemented")
    }
}
