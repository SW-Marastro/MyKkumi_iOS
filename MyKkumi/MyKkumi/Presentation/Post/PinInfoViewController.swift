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
        view.backgroundColor = .black.withAlphaComponent(0.3)
    }
    
    override func setupHierarchy() {
        view.addSubview(emptyView)
        emptyView.addSubview(productNameStack)
        emptyView.addSubview(purchaseInfoStack)
        emptyView.addSubview(cancelButton)
        emptyView.addSubview(saveButton)
        productNameStack.addArrangedSubview(productNameLabel)
        productNameStack.addArrangedSubview(productNameTextField)
        purchaseInfoStack.addArrangedSubview(purchaseInfoLabel)
        purchaseInfoStack.addArrangedSubview(purchaseTextField)
    }
    
    public override func setupBind(viewModel: PinInfoViewModelProtocol) {
        self.viewModel = viewModel
        
        self.cancelButton.rx.tap
            .map{ self.viewModel.uuId }
            .bind(to: viewModel.cancelButtonTap)
            .disposed(by: disposeBag)
        
        self.saveButton.rx.tap
            .map { self.viewModel.uuId }
            .bind(to: viewModel.saveButtonTap)
            .disposed(by: disposeBag)
        
        self.productNameTextField.rx.text.orEmpty
            .bind(to: self.viewModel.productName)
            .disposed(by: disposeBag)
        
        self.purchaseTextField.rx.text.orEmpty
            .bind(to: self.viewModel.purchaseInfo)
            .disposed(by: disposeBag)
        
        self.viewModel.sholudDismiss
            .drive(onNext: {[weak self] _ in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        self.viewModel.saveComplete
            .drive(onNext: {[weak self] _ in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        self.viewModel.alertNameBlank
            .drive(onNext: {[weak self] _ in
                guard let self = self else { return }
                let alert = UIAlertController(title: "Error", message: "제품 이름을 입력하지 않았습니다.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
    
    override func setupLayout() {
        //EmptyView
        NSLayoutConstraint.activate([
            emptyView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            emptyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyView.heightAnchor.constraint(equalToConstant: 155)
        ])
        
        //ProductName
        NSLayoutConstraint.activate([
            productNameStack.topAnchor.constraint(equalTo: emptyView.topAnchor, constant: 32),
            productNameStack.leadingAnchor.constraint(equalTo: emptyView.leadingAnchor, constant: 86),
            productNameStack.trailingAnchor.constraint(equalTo: emptyView.trailingAnchor, constant: -86)
        ])
        
        //PurchaseInfo
        NSLayoutConstraint.activate([
            purchaseInfoStack.topAnchor.constraint(equalTo: productNameStack.bottomAnchor, constant: 10),
            purchaseInfoStack.leadingAnchor.constraint(equalTo: emptyView.leadingAnchor, constant: 86),
            purchaseInfoStack.trailingAnchor.constraint(equalTo: emptyView.trailingAnchor, constant: -86)
        ])
        
        //Buttons
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: purchaseInfoStack.bottomAnchor, constant: 13),
            cancelButton.leadingAnchor.constraint(equalTo: emptyView.leadingAnchor,constant: 27),
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
    
    private var emptyView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
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
