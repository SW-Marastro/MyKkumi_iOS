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
        view.addSubview(mainStack)
        mainStack.addArrangedSubview(buttonStack)
        buttonStack.addArrangedSubview(skipButton)
        buttonStack.addArrangedSubview(nextButton)
    }
    
    public override func setupBind(viewModel: CollectCategoryViewModelProtocol) {
        self.viewModel = viewModel
    }
    
    public override func setupViewProperty() {
       
    }
    
    public override func setupLayout() {

    }
    
    private var mainStack : UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        return stack
    }()
    
    private var buttonStack : UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        return stack
    }()
    
    private var skipButton : UIButton = {
        let button = UIButton()
        button.setTitle("건너뛰기", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.backgroundColor = .white
        return button
    }()
    
    private var nextButton : UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 10
        return button
    }()
}

