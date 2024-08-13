//
//  PostCategoryViewController.swift
//  MyKkumi
//
//  Created by 최재혁 on 8/12/24.
//

import Foundation
import UIKit
import RxSwift

class PostCategoryViewController : BaseViewController<PostCategoryViewModelProtocol> {
    
    var viewModel : PostCategoryViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black.withAlphaComponent(0.3)
    }
    
    override func setupBind(viewModel: PostCategoryViewModelProtocol) {
        self.viewModel = viewModel
        
        self.rx.viewDidLoad
            .bind(to: viewModel.viewDidLoad)
            .disposed(by: disposeBag)
        
        self.viewModel.sholudDrawCategory
            .drive(onNext: {[weak self] categories in
                guard let self = self else { return }
                
                for category in categories.categories {
                    let categoryView  : UIStackView = {
                        let view = UIStackView()
                        view.translatesAutoresizingMaskIntoConstraints = false
                        view.axis = .vertical
                        view.spacing = 3
                        return view
                    }()
                    let label : UILabel = {
                        let label = UILabel()
                        label.translatesAutoresizingMaskIntoConstraints = false
                        label.text = category.name
                        return label
                    }()
                    let buttonStack : UIStackView = {
                        let stack = UIStackView()
                        stack.translatesAutoresizingMaskIntoConstraints = false
                        stack.axis = .horizontal
                        stack.spacing = 3
                        return stack
                    }()
                    
                    categoryView.addArrangedSubview(label)
                    categoryView.addArrangedSubview(buttonStack)
                    
                    NSLayoutConstraint.activate([
                        label.topAnchor.constraint(equalTo: categoryView.topAnchor),
                        label.leadingAnchor.constraint(equalTo: categoryView.leadingAnchor)
                    ])
                    
                    NSLayoutConstraint.activate([
                        buttonStack.leadingAnchor.constraint(equalTo: categoryView.leadingAnchor),
                        buttonStack.topAnchor.constraint(equalTo: label.bottomAnchor)
                    ])
                    
                    for subcategory in category.subCategories {
                        let button = UIButton()
                        button.translatesAutoresizingMaskIntoConstraints = false
                        button.tag = Int(subcategory.id)
                        button.setTitle(subcategory.name, for: .normal)
                        button.setTitleColor(.black, for: .normal)
                        button.rx.tap
                            .subscribe(onNext: {[weak self] _ in
                                guard let self = self else { return }
                                self.viewModel.categoryButtonTap.onNext(Int(subcategory.id))
                            })
                            .disposed(by: disposeBag)
                        buttonStack.addArrangedSubview(button)
                    }
                    
                    self.categoryStack.addArrangedSubview(categoryView)
                }
            })
            .disposed(by: disposeBag)
        
        self.completeButton.rx.tap
            .bind(to: self.viewModel.completeButtonTap)
            .disposed(by: disposeBag)
        
        self.viewModel.dismissView
            .drive(onNext: {[weak self] result in
                guard let self = self  else {return}
                if result {
                    self.navigationController?.popViewController(animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
    
    override func setupHierarchy() {
        view.addSubview(backGroundview)
        backGroundview.addSubview(categoryLabel)
        backGroundview.addSubview(categoryScrollView)
        backGroundview.addSubview(completeButton)
        categoryScrollView.addSubview(categoryStack)
    }
    
    override func setupLayout() {
        //backGroundView
        NSLayoutConstraint.activate([
            backGroundview.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backGroundview.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backGroundview.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backGroundview.heightAnchor.constraint(equalToConstant: view.safeAreaLayoutGuide.layoutFrame.height / 2)
        ])
        
        //categoryLabel
        NSLayoutConstraint.activate([
            categoryLabel.topAnchor.constraint(equalTo: backGroundview.topAnchor, constant: 32),
            categoryLabel.leadingAnchor.constraint(equalTo: backGroundview.leadingAnchor, constant: 24)
        ])
        
        //categoryScrollView
        NSLayoutConstraint.activate([
            categoryScrollView.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 7),
            categoryScrollView.leadingAnchor.constraint(equalTo: backGroundview.leadingAnchor, constant: 35),
            categoryScrollView.trailingAnchor.constraint(equalTo: backGroundview.trailingAnchor, constant: -35),
            categoryScrollView.bottomAnchor.constraint(equalTo: completeButton.topAnchor, constant: -7)
        ])
        
        NSLayoutConstraint.activate([
            categoryStack.topAnchor.constraint(equalTo: categoryScrollView.topAnchor),
            categoryStack.leadingAnchor.constraint(equalTo: categoryScrollView.leadingAnchor),
            categoryStack.trailingAnchor.constraint(equalTo: categoryScrollView.trailingAnchor),
            categoryStack.bottomAnchor.constraint(equalTo: categoryScrollView.bottomAnchor),
            categoryStack.widthAnchor.constraint(equalTo: categoryScrollView.widthAnchor)
        ])
        
        //CompleteButton
        NSLayoutConstraint.activate([
            completeButton.leadingAnchor.constraint(equalTo: backGroundview.leadingAnchor, constant: 35),
            completeButton.trailingAnchor.constraint(equalTo: backGroundview.trailingAnchor, constant: -35),
            completeButton.bottomAnchor.constraint(equalTo: backGroundview.bottomAnchor, constant: -7)
        ])
    }
    
    private let backGroundview : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    private let categoryLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "카테고리"
        return label
    }()
    
    private let categoryScrollView : UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let categoryStack : UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 5
        return stack
    }()
    
    private let completeButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("완료", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderColor = CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        return button
    }()
}
