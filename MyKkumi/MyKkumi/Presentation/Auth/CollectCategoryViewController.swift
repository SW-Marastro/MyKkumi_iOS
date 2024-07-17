//
//  CollectCategoryViewController.swift
//  MyKkumi
//
//  Created by 최재혁 on 7/14/24.
//

import Foundation
import UIKit
import RxSwift


class CollectCategoryViewController : BaseViewController<CollectCategoryViewModelProtocol> {
    
    var viewModel: CollectCategoryViewModelProtocol!
    
    override init() {
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public override func setupHierarchy() {
       
    }
    
    public override func setupBind(viewModel: CollectCategoryViewModelProtocol) {
        self.viewModel = viewModel
    }
    
    public override func setupViewProperty() {
       
    }
    
    public override func setupLayout() {

    }
}

