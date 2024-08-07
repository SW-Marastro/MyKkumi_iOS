//
//  PinInfoViewController.swift
//  MyKkumi
//
//  Created by 최재혁 on 8/7/24.
//

import Foundation
import UIKit

class PinInfoViewController : BaseViewController<PinInfoViewModelProtocol> {
    var viewModel : PinInfoViewModelProtocol!
    
    override init() {
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupHierarchy() {
        view.addSubview(productNameStack)
        view.addSubview(purchaseInfoStack)
        view.addSubview(cancelButton)
        view.addSubview(saveButton)
        productNameStack.addArrangedSubview(productNameLabel)
        productNameStack.addArrangedSubview(productNameTextField)
        purchaseInfoStack.addArrangedSubview(purchaseInfoLabel)
        purchaseInfoStack.addArrangedSubview(purchaseTextField)
    }
    
    public override func setupBind(viewModel: PinInfoViewModelProtocol) {
        self.viewModel = viewModel
        
        self.cancelButton.rx.tap
            .map{ self.viewModel.index }
            .bind(to: viewModel.cancelButtonTap)
            .disposed(by: disposeBag)
        
        self.saveButton.rx.tap
            .map { self.viewModel.index }
            .bind(to: viewModel.saveButtonTap)
            .disposed(by: disposeBag)
        
        self.productNameTextField.rx.text.orEmpty
            .bind(to: self.viewModel.productName)
            .disposed(by: disposeBag)
        
        self.purchaseTextField.rx.text.orEmpty
            .bind(to: self.viewModel.purchaseInfo)
            .disposed(by: disposeBag)
    }
    
    override func setupLayout() {
        //ProductName
        NSLayoutConstraint.activate([
            productNameStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 32),
            productNameStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 86),
            productNameStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -86)
        ])
        
        //PurchaseInfo
        NSLayoutConstraint.activate([
            purchaseInfoStack.topAnchor.constraint(equalTo: productNameStack.bottomAnchor, constant: 10),
            purchaseInfoStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 86),
            purchaseInfoStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -86)
        ])
        
        //Buttons
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: purchaseInfoStack.topAnchor, constant: 26),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 27),
            cancelButton.heightAnchor.constraint(equalToConstant: 32),
            cancelButton.widthAnchor.constraint(equalToConstant: 167)
        ])
        
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: cancelButton.topAnchor),
            saveButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: 8),
            saveButton.heightAnchor.constraint(equalToConstant: 32),
            saveButton.widthAnchor.constraint(equalToConstant: 167)
        ])
    }
    
    private var productNameStack : UIStackView  = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 27
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private var purchaseInfoStack : UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 27
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private var productNameLabel : UILabel = {
        let label = UILabel()
        label.text = "제품명"
        label.textColor = .black
        return label
    }()
    
    private var productNameTextField : UITextField = {
        let textFeild = UITextField()
        textFeild.borderStyle = .line
        textFeild.translatesAutoresizingMaskIntoConstraints = false
        return textFeild
    }()
    
    private var purchaseInfoLabel : UILabel = {
        let label = UILabel()
        label.text = "구매처"
        label.textColor = .black
        return label
    }()
    
    private var purchaseTextField : UITextField = {
        let textFeild = UITextField()
        textFeild.borderStyle = .line
        textFeild.translatesAutoresizingMaskIntoConstraints = false
        return textFeild
    }()
    
    private var cancelButton : UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.backgroundColor = .gray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var saveButton : UIButton = {
        let button = UIButton()
        button.setTitle("저장", for: .normal)
        button.backgroundColor = .gray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
}
