//
//  TestView.swift
//  MyKkumi
//
//  Created by 최재혁 on 7/8/24.
//

import Foundation
import UIKit
import RxSwift

class TestView : BaseViewController<TestviewModelProtocol> {
    var viewModel : TestviewModelProtocol!
    var printvalue : Int = 0
    
    override init() {
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public override func setupBind(viewModel: TestviewModelProtocol) {
        self.viewModel = viewModel
        
        self.rx.viewDidLoad
            .bind(to: viewModel.viewdidLoad)
            .disposed(by: disposeBag)
        
        viewModel.getData
            .emit(onNext: {value in
                print(value)
            })
            .disposed(by: disposeBag)
    }
}
