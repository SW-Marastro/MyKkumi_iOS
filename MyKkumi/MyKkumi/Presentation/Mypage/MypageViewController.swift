//
//  MypageViewController.swift
//  MyKkumi
//
//  Created by 최재혁 on 6/25/24.
//

import Foundation
import RxSwift
import UIKit
import SafariServices

class MypageViewController : BaseViewController<MypageViewModelProtocol> {
    var viewModel : MypageViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupHierarchy() {
        
    }
    
    override func setupBind(viewModel: MypageViewModelProtocol) {
        self.viewModel = viewModel
        
        
    }
    
    override func setupLayout() {

    }
}
