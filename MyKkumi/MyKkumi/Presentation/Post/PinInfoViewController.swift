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
        emptyView.addSubview(cancelButton)
        emptyView.addSubview(saveButton)
        emptyView.addSubview(productNameLabel)
        emptyView.addSubview(productNameTextView)
        emptyView.addSubview(purchaseInfoLabel)
        emptyView.addSubview(purchaseTextView)
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
        
        self.productNameTextView.rx.text.orEmpty
            .bind(to: self.viewModel.productNameInput)
            .disposed(by: disposeBag)
        
        self.purchaseTextView.rx.text.orEmpty
            .bind(to: self.viewModel.purchaseInfoInput)
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
        
        self.viewModel.productName
            .subscribe(onNext: {[weak self] name in
                guard let self = self else { return }
                
                if name != "" {
                    let title = self.saveButton.attributedTitle(for: .normal)!.string
                    self.saveButton.isEnabled = true
                    self.saveButton.backgroundColor = AppColor.primary.color
                    self.saveButton.setAttributedTitle(NSAttributedString(string : title, attributes: Typography.body15SemiBold(color: AppColor.white).attributes), for: .normal)
                } else {
                    let title = self.saveButton.attributedTitle(for: .normal)!.string
                    self.saveButton.isEnabled = false
                    self.saveButton.backgroundColor = AppColor.neutral50.color
                    self.saveButton.setAttributedTitle(NSAttributedString(string : title, attributes: Typography.body15SemiBold(color: AppColor.neutral300).attributes), for: .normal)
                }
            })
            .disposed(by: disposeBag)
    }
    
    override func setupLayout() {
        //EmptyView
        NSLayoutConstraint.activate([
            emptyView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            emptyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyView.heightAnchor.constraint(equalToConstant: view.frame.height/1.5)
        ])
        
        NSLayoutConstraint.activate([
            productNameLabel.topAnchor.constraint(equalTo: emptyView.topAnchor, constant: 20),
            productNameLabel.leadingAnchor.constraint(equalTo: emptyView.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            productNameTextView.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor, constant: 8),
            productNameTextView.leadingAnchor.constraint(equalTo: emptyView.leadingAnchor, constant: 20),
            productNameTextView.trailingAnchor.constraint(equalTo: emptyView.trailingAnchor, constant: -20),
            productNameTextView.heightAnchor.constraint(equalToConstant: 70),
            namePlaceHolderLabel.topAnchor.constraint(equalTo: productNameTextView.topAnchor, constant: 14),
            namePlaceHolderLabel.leadingAnchor.constraint(equalTo: productNameTextView.leadingAnchor, constant: 16),
            namePlaceHolderLabel.trailingAnchor.constraint(equalTo: productNameTextView.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            purchaseInfoLabel.topAnchor.constraint(equalTo: productNameTextView.bottomAnchor, constant: 20),
            purchaseInfoLabel.leadingAnchor.constraint(equalTo: emptyView.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            purchaseTextView.topAnchor.constraint(equalTo: purchaseInfoLabel.bottomAnchor, constant: 8),
            purchaseTextView.leadingAnchor.constraint(equalTo: emptyView.leadingAnchor, constant: 20),
            purchaseTextView.trailingAnchor.constraint(equalTo: emptyView.trailingAnchor, constant: -20),
            purchaseTextView.heightAnchor.constraint(equalToConstant: 70),
            infoPlaceHolderLabel.topAnchor.constraint(equalTo: purchaseTextView.topAnchor, constant: 14),
            infoPlaceHolderLabel.leadingAnchor.constraint(equalTo: purchaseTextView.leadingAnchor, constant: 16),
            infoPlaceHolderLabel.trailingAnchor.constraint(equalTo: purchaseTextView.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 10),
            cancelButton.leadingAnchor.constraint(equalTo: emptyView.leadingAnchor, constant: 20),
            cancelButton.heightAnchor.constraint(equalToConstant: 54),
            cancelButton.widthAnchor.constraint(equalToConstant: 104)
        ])
        
        NSLayoutConstraint.activate([
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 10),
            saveButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: 11),
            saveButton.trailingAnchor.constraint(equalTo: emptyView.trailingAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalToConstant: 54)
        ])
    }
    
    private var emptyView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        return view
    }()
    
    private var productNameLabel : UILabel = {
        let label = UILabel()
        label.text = "제품명"
        label.textColor = .black
        return label
    }()
    
    private var productNameTextView : UITextView = {
        let textView = UITextView()
        textView.keyboardType = .default
        textView.returnKeyType = .done
        textView.isUserInteractionEnabled = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = AppColor.neutral200.color.cgColor
        textView.layer.cornerRadius = 12
        textView.textContainerInset = UIEdgeInsets(top: 14, left: 16, bottom: 14, right: 16)
        return textView
    }()
    
    private var namePlaceHolderLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.attributedText = NSAttributedString(string : "최대 20자 까지 작성할 수 있어요.", attributes: Typography.body14Medium(color: AppColor.neutral300).attributes)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    
    private var purchaseInfoLabel : UILabel = {
        let label = UILabel()
        label.text = "구매처"
        label.textColor = .black
        return label
    }()
    
    private var purchaseTextView : UITextView = {
        let textView = UITextView()
        textView.keyboardType = .default
        textView.returnKeyType = .done
        textView.isUserInteractionEnabled = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = AppColor.neutral200.color.cgColor
        textView.layer.cornerRadius = 12
        textView.textContainerInset = UIEdgeInsets(top: 14, left: 16, bottom: 14, right: 16)
        return textView
    }()
    
    private var infoPlaceHolderLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.attributedText = NSAttributedString(string : "구매한 사이트의 URL을 작성해 주세요 (예 https//www.shop.com)", attributes: Typography.body14Medium(color: AppColor.neutral300).attributes)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    
    private var cancelButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = AppColor.neutral50.color
        button.setAttributedTitle(NSAttributedString(string: "취소", attributes: Typography.body15SemiBold(color: AppColor.neutral700).attributes), for: .normal)
        button.layer.cornerRadius = 12
        return button
    }()
    
    private var saveButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = AppColor.neutral50.color
        button.setAttributedTitle(NSAttributedString(string: "저장하기", attributes: Typography.body15SemiBold(color: AppColor.neutral300).attributes), for: .normal)
        button.layer.cornerRadius = 12
        button.isEnabled = false
        return button
    }()
}


//@available(iOS 17, *)
//#Preview(traits: .defaultLayout, body: {
//    let view = PinInfoViewController()
//
//    return view
//})
