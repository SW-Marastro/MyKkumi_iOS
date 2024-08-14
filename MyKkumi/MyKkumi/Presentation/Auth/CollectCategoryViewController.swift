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
        view.addSubview(selectCategoryLabel)
        view.addSubview(categoryScrollView)
        view.addSubview(buttonView)
        categoryScrollView.addSubview(categoryStackView)
        buttonView.addSubview(skipButton)
        buttonView.addSubview(nextButton)
    }
    
    public override func setupBind(viewModel: CollectCategoryViewModelProtocol) {
        self.viewModel = viewModel
        
        self.rx.viewDidLoad
            .bind(to: self.viewModel.viewdDidLoad)
            .disposed(by: disposeBag)
        
        self.nextButton.rx.tap
            .bind(to: self.viewModel.nextButtonTap)
            .disposed(by: disposeBag)
        
        self.skipButton.rx.tap
            .bind(to: self.viewModel.skipButtonTap)
            .disposed(by: disposeBag)
        
        self.viewModel.shouldPushMakeProfile
            .drive(onNext : {
                let makeProfileVC = MakeProfileViewController()
                let cateogry = viewModel.categoryRelay.value
                makeProfileVC.setupBind(viewModel: MakeProfileViewModel(categoryList: cateogry))
                self.navigationController?.pushViewController(makeProfileVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        self.viewModel.shouldSkipView
            .drive(onNext : {
                let makeProfileVC = MakeProfileViewController()
                makeProfileVC.setupBind(viewModel: MakeProfileViewModel())
                self.navigationController?.pushViewController(makeProfileVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        self.viewModel.shouldDrawCategory
            .drive(onNext: {[weak self] categories in
                guard let self = self else { return }
                let categoryValue = categories.categories
                
                for category in categoryValue {
                    let view : UIView = {
                        let view = UIView()
                        view.translatesAutoresizingMaskIntoConstraints = false
                        return view
                    }()
                    let buttonStackView : UIStackView = {
                        let stack = UIStackView()
                        stack.translatesAutoresizingMaskIntoConstraints = false
                        stack.axis = .horizontal
                        stack.spacing = 16
                        return stack
                    }()
                    let label : UILabel = {
                        let label = UILabel()
                        label.translatesAutoresizingMaskIntoConstraints = false
                        label.attributedText = NSAttributedString(string: category.name, attributes: Typography.heading18Bold.attributes)
                        label.textColor = AppColor.neutral900.color
                        return label
                    }()
                    
                    view.addSubview(label)
                    view.addSubview(buttonStackView)
                    categoryStackView.addArrangedSubview(view)
                    NSLayoutConstraint.activate([
                        view.leadingAnchor.constraint(equalTo: categoryStackView.leadingAnchor),
                        view.trailingAnchor.constraint(equalTo: categoryStackView.trailingAnchor),
                        view.heightAnchor.constraint(equalToConstant: 123)
                    ])
                    
                    NSLayoutConstraint.activate([
                        label.topAnchor.constraint(equalTo: view.topAnchor),
                        label.leadingAnchor.constraint(equalTo: view.leadingAnchor)
                    ])
                    
                    NSLayoutConstraint.activate([
                        buttonStackView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8),
                        buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
                    ])
                    
                    for subcategory in category.subCategories {
                        let subView : UIView = {
                            let view = UIView()
                            view.translatesAutoresizingMaskIntoConstraints = false
                            return view
                        }()
                        
                        let button : UIButton = {
                            let button = UIButton()
                            button.translatesAutoresizingMaskIntoConstraints = false
                            return button
                        }()
                        
                        let buttonImage  : UIImageView = {
                            let image = UIImageView()
                            image.translatesAutoresizingMaskIntoConstraints = false
                            image.backgroundColor = AppColor.neutral50.color
                            image.layer.cornerRadius = 16
                            return image
                        }()
                        
                        let subLabel : UILabel = {
                            let label = UILabel()
                            label.translatesAutoresizingMaskIntoConstraints = false
                            let paragraphStyle = NSMutableParagraphStyle()
                            paragraphStyle.alignment = .center
                            paragraphStyle.lineHeightMultiple = 1.4

                            var attributes = Typography.body13Medium.attributes
                            attributes[.paragraphStyle] = paragraphStyle
                            label.attributedText = NSAttributedString(string: subcategory.name, attributes: attributes)
                            return label
                        }()
                        
                        button.rx.tap
                            .subscribe(onNext: {
                                viewModel.categoryTap.onNext(Int(subcategory.id))
                            })
                            .disposed(by: disposeBag)
                        
                        subView.addSubview(button)
                        subView.addSubview(buttonImage)
                        subView.addSubview(subLabel)
                        subView.bringSubviewToFront(button)
                        
                        buttonStackView.addArrangedSubview(subView)
                        
                        NSLayoutConstraint.activate([
                            subView.heightAnchor.constraint(equalToConstant: 98),
                            subView.widthAnchor.constraint(equalToConstant: 72),
                            button.topAnchor.constraint(equalTo: subView.topAnchor),
                            button.leadingAnchor.constraint(equalTo: subView.leadingAnchor),
                            button.trailingAnchor.constraint(equalTo: subView.trailingAnchor),
                            button.bottomAnchor.constraint(equalTo: subView.bottomAnchor)
                        ])
                        
                        NSLayoutConstraint.activate([
                            buttonImage.topAnchor.constraint(equalTo: subView.topAnchor),
                            buttonImage.leadingAnchor.constraint(equalTo: subView.leadingAnchor),
                            buttonImage.trailingAnchor.constraint(equalTo: subView.trailingAnchor),
                            buttonImage.bottomAnchor.constraint(equalTo: subLabel.topAnchor, constant: -6)
                        ])
                        
                        NSLayoutConstraint.activate([
                            subLabel.leadingAnchor.constraint(equalTo: subView.leadingAnchor),
                            subLabel.trailingAnchor.constraint(equalTo: subView.trailingAnchor),
                            subLabel.bottomAnchor.constraint(equalTo: subView.bottomAnchor)
                        ])
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    public override func setupLayout() {
        NSLayoutConstraint.activate([
            selectCategoryLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 84),
            selectCategoryLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            categoryScrollView.topAnchor.constraint(equalTo: selectCategoryLabel.bottomAnchor, constant: 24),
            categoryScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            categoryScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            categoryScrollView.bottomAnchor.constraint(equalTo: buttonView.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            categoryStackView.topAnchor.constraint(equalTo: categoryScrollView.topAnchor),
            categoryStackView.leadingAnchor.constraint(equalTo: categoryScrollView.leadingAnchor),
            categoryStackView.trailingAnchor.constraint(equalTo: categoryScrollView.trailingAnchor),
            categoryStackView.bottomAnchor.constraint(equalTo: categoryScrollView.bottomAnchor),
            categoryStackView.widthAnchor.constraint(equalTo: categoryScrollView.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            buttonView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buttonView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            buttonView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            buttonView.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        NSLayoutConstraint.activate([
            skipButton.topAnchor.constraint(equalTo: buttonView.topAnchor, constant: 15),
            skipButton.bottomAnchor.constraint(equalTo: buttonView.bottomAnchor, constant: -10),
            skipButton.leadingAnchor.constraint(equalTo: buttonView.leadingAnchor, constant: 20),
            skipButton.widthAnchor.constraint(equalToConstant: 104)
        ])
        
        NSLayoutConstraint.activate([
            nextButton.topAnchor.constraint(equalTo: buttonView.topAnchor, constant: 15),
            nextButton.bottomAnchor.constraint(equalTo: buttonView.bottomAnchor, constant: -10),
            nextButton.leadingAnchor.constraint(equalTo: skipButton.trailingAnchor, constant: 11),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private var selectCategoryLabel : UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "관심있는 취미를 선택해주세요", attributes: Typography.heading20Bold.attributes)
        label.textColor = AppColor.neutral900.color
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var categoryScrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private var categoryStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 32
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var buttonView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let topLine = CALayer()
        topLine.backgroundColor = AppColor.neutral100.color.cgColor
        topLine.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 1)
        view.layer.addSublayer(topLine)
        return view
    }()
    
    private var skipButton : UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "건너뛰기", attributes: Typography.body15SemiBold.attributes), for: .normal)
        button.setTitleColor(AppColor.neutral700.color, for: .normal)
        button.backgroundColor = AppColor.neutral50.color
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var nextButton : UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "다음", attributes: Typography.body15SemiBold.attributes), for: .normal)
        button.setTitleColor(AppColor.white.color, for: .normal)
        button.backgroundColor = AppColor.primary.color
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
}


