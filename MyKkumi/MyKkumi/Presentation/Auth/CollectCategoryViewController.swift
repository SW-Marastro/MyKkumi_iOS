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
        mainStack.addSubview(buttonStack)
        mainStack.addSubview(selectCategoryLabel)
        mainStack.addSubview(categoryCollectionView)
        buttonStack.addSubview(skipButton)
        buttonStack.addSubview(nextButton)
    }
    
    public override func setupBind(viewModel: CollectCategoryViewModelProtocol) {
        self.viewModel = viewModel
        
        self.nextButton.rx.tap
            .bind(to: self.viewModel.nextButtonTap)
            .disposed(by: disposeBag)
        
        self.viewModel.sholdPushMakeProfile
            .drive(onNext : {
                let makeProfileVC = MakeProfileViewController()
                makeProfileVC.setupBind(viewModel: MakeProfileViewModel())
                self.navigationController?.pushViewController(makeProfileVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    public override func setupDelegate() {
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
    }
    
    public override func setupLayout() {
        //mainStack
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: view.topAnchor),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainStack.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
        
        //ButtomStack
        NSLayoutConstraint.activate([
            buttonStack.leadingAnchor.constraint(equalTo: mainStack.leadingAnchor),
            buttonStack.bottomAnchor.constraint(equalTo: mainStack.bottomAnchor),
            buttonStack.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor)
        ])
        
        //nextButton
        NSLayoutConstraint.activate([
            nextButton.leadingAnchor.constraint(equalTo: buttonStack.leadingAnchor, constant: 35),
            nextButton.trailingAnchor.constraint(equalTo: buttonStack.trailingAnchor, constant: -35),
            nextButton.bottomAnchor.constraint(equalTo: buttonStack.bottomAnchor, constant: -48)
        ])
        
        //skipButton
        NSLayoutConstraint.activate([
            skipButton.trailingAnchor.constraint(equalTo: buttonStack.trailingAnchor, constant: -35),
            skipButton.leadingAnchor.constraint(equalTo: buttonStack.leadingAnchor, constant: 35),
            skipButton.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -7)
        ])
        
        //selectCategoryLabel
        NSLayoutConstraint.activate([
            selectCategoryLabel.topAnchor.constraint(equalTo: mainStack.topAnchor, constant: 77),
            selectCategoryLabel.leadingAnchor.constraint(equalTo: mainStack.leadingAnchor, constant: 99)
        ])
        
        //categoryCollectionView
        NSLayoutConstraint.activate([
            categoryCollectionView.topAnchor.constraint(equalTo: selectCategoryLabel.bottomAnchor, constant: 24),
            categoryCollectionView.leadingAnchor.constraint(equalTo: mainStack.leadingAnchor, constant: 16),
            categoryCollectionView.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor, constant: -16),
            categoryCollectionView.bottomAnchor.constraint(equalTo: buttonStack.topAnchor, constant: -24)
        ])
    }
    
    private var mainStack : UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private var buttonStack : UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 14
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private var skipButton : UIButton = {
        let button = UIButton()
        button.setTitle("건너뛰기", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var nextButton : UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var selectCategoryLabel : UILabel = {
        let label = UILabel()
        label.text = "관심있는 취미를 선택해주세요"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var categoryCollectionView : CategoryCollectionView = {
        let collectionView = CategoryCollectionView(frame: CGRect.zero, collectionViewLayout: CategoryCollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        return collectionView
    }()
}

extension CollectCategoryViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width/3, height: collectionView.bounds.height/3)
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.categoryRelay.value.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.cellID, for: indexPath) as! CategoryCollectionViewCell
        cell.label.text = viewModel.categoryRelay.value[indexPath.row]
        return cell
    }
}

