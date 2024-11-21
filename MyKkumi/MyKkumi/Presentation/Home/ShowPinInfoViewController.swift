//
//  ShowPinInfoViewController.swift
//  MyKkumi
//
//  Created by 최재혁 on 11/22/24.
//

import Foundation
import UIKit
import FirebaseAnalytics

class ShowPinInfoViewController : BaseViewController<ProductInfo> {
    override init() {
        super.init()
        
        Analytics.logEvent(AnalyticsEventScreenView, parameters: [
            AnalyticsParameterScreenName: LogEvnetParameter.PinInfoViewController.value,
            AnalyticsParameterScreenClass: NSStringFromClass(type(of: self))
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black.withAlphaComponent(0.3)
        closeButton.addTarget(self, action: #selector(popView), for: .touchUpInside)
    }
    
    override func setupHierarchy() {
        view.addSubview(emptyView)
        emptyView.addSubview(closeButton)
        emptyView.addSubview(infoLabel)
        emptyView.addSubview(productNameLabel)
        emptyView.addSubview(productNameView)
        emptyView.addSubview(productNameInfo)
        emptyView.addSubview(purchaseInfoLabel)
        emptyView.addSubview(purchaseView)
        emptyView.addSubview(purchaseInfo)
    }
    
    override func setupDelegate() {
        
    }
    
    public override func setupBind(viewModel : ProductInfo) {
        self.productNameInfo.text = viewModel.name
        
        if let purchase = viewModel.url {
            self.purchaseInfo.text = purchase
        }
    }
    
    override func setupLayout() {
        //EmptyView
        NSLayoutConstraint.activate([
            emptyView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            emptyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyView.heightAnchor.constraint(equalToConstant: view.frame.height/2)
        ])
        
        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: emptyView.topAnchor, constant: 16),
            infoLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            productNameLabel.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 28),
            productNameLabel.leadingAnchor.constraint(equalTo: emptyView.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            productNameView.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor, constant: 8),
            productNameView.leadingAnchor.constraint(equalTo: emptyView.leadingAnchor, constant: 20),
            productNameView.trailingAnchor.constraint(equalTo: emptyView.trailingAnchor, constant: -20),
            productNameView.heightAnchor.constraint(equalToConstant: 49),
            
            productNameInfo.centerYAnchor.constraint(equalTo: productNameView.centerYAnchor),
            productNameInfo.leadingAnchor.constraint(equalTo: productNameView.leadingAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            purchaseInfoLabel.topAnchor.constraint(equalTo: productNameView.bottomAnchor, constant: 20),
            purchaseInfoLabel.leadingAnchor.constraint(equalTo: emptyView.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            purchaseView.topAnchor.constraint(equalTo: purchaseInfoLabel.bottomAnchor, constant: 8),
            purchaseView.leadingAnchor.constraint(equalTo: emptyView.leadingAnchor, constant: 20),
            purchaseView.trailingAnchor.constraint(equalTo: emptyView.trailingAnchor, constant: -20),
            purchaseView.heightAnchor.constraint(equalToConstant: 49),
            
            purchaseInfo.centerYAnchor.constraint(equalTo: purchaseView.centerYAnchor),
            purchaseInfo.leadingAnchor.constraint(equalTo: purchaseView.leadingAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            closeButton.bottomAnchor.constraint(equalTo: emptyView.bottomAnchor, constant: -44),
            closeButton.leadingAnchor.constraint(equalTo: emptyView.leadingAnchor, constant: 20),
            closeButton.trailingAnchor.constraint(equalTo: emptyView.trailingAnchor, constant: -20),
            closeButton.heightAnchor.constraint(equalToConstant: 54)
        ])
    }
    
    private var emptyView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        return view
    }()
    
    private var infoLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "제품 정보"
        label.font = Typography.heading18SemiBold(color: AppColor.neutral900).font()
        return label
    }()
    
    private var productNameLabel : UILabel = {
        let label = UILabel()
        label.text = "제품명"
        label.textColor = AppColor.neutral700.color
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var productNameView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.backgroundColor = AppColor.primary.color.withAlphaComponent(0.1)
        return view
    }()
    
    private var productNameInfo : UILabel = {
        let label = UILabel()
        label.text = "제품명이 없습니다."
        label.font = Typography.body14Medium(color: AppColor.neutral900).font()
        label.textColor = AppColor.neutral900.color
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    
    private var purchaseInfoLabel : UILabel = {
        let label = UILabel()
        label.text = "구매처"
        label.textColor = AppColor.neutral700.color
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var purchaseView : UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.backgroundColor = AppColor.primary.color.withAlphaComponent(0.1)
        return view
    }()
    
    private var purchaseInfo : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "구매 정보가 없습니다."
        label.font = Typography.body14Medium(color: AppColor.neutral900).font()
        label.textColor = AppColor.neutral900.color
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    
    private var closeButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = AppColor.primary.color
        button.setAttributedTitle(NSAttributedString(string: "닫기", attributes: Typography.body15SemiBold(color: AppColor.white).attributes), for: .normal)
        button.layer.cornerRadius = 12
        return button
    }()
    
    @objc private func popView() {
        self.dismiss(animated: true)
    }
}
