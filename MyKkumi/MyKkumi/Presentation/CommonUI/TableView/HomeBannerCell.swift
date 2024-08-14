//
//  HomeBannerCell.swift
//  MyKkumi
//
//  Created by 최재혁 on 7/5/24.
//

import UIKit
import RxSwift
import RxDataSources

open class HomeBannerCell : UITableViewCell {
    public static let cellID = "HomeBannerCell"
    private var disposeBag = DisposeBag()
    var viewModel : BannerCellViewModelProtocol!
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initUI()
        initAttribute()
    }
    
    public func bind(viewModel : BannerCellViewModelProtocol) {
        self.viewModel = viewModel
        
        self.bannerPage.rx.tap
            .bind(to: viewModel.bannerPageTap)
            .disposed(by: disposeBag)
    }
    
    public func setCellData(bannerData : [BannerVO]) {
        for banner in bannerData {
            let bannerView : UIView = {
                let view = UIView()
                view.translatesAutoresizingMaskIntoConstraints = false
                view.backgroundColor = AppColor.neutral50.color
                return view
            }()
            
            let button : UIButton = {
                let button = UIButton()
                button.tag = banner.id
                button.translatesAutoresizingMaskIntoConstraints = false
                return button
            }()
            
            let imageView : UIImageView = {
                let image = UIImageView()
                image.translatesAutoresizingMaskIntoConstraints = false
                image.load(url: URL(string : banner.imageURL)!)
                return image
            }()
            
            button.rx.tap
                .map{ button.tag }
                .subscribe(onNext: {[weak self] tag in
                    guard let self = self else { return }
                    self.viewModel.bannerCellTap.onNext(tag)
                })
                .disposed(by: disposeBag)

            bannerView.addSubview(button)
            bannerView.addSubview(imageView)
            
            bannerStackView.addArrangedSubview(bannerView)
            
            NSLayoutConstraint.activate([
                bannerView.topAnchor.constraint(equalTo: bannerStackView.topAnchor),
                bannerView.leadingAnchor.constraint(equalTo: bannerStackView.leadingAnchor),
                bannerView.trailingAnchor.constraint(equalTo: bannerStackView.trailingAnchor),
                bannerView.bottomAnchor.constraint(equalTo: bannerStackView.bottomAnchor)
            ])
            
            NSLayoutConstraint.activate([
                button.topAnchor.constraint(equalTo: bannerView.topAnchor),
                button.leadingAnchor.constraint(equalTo: bannerView.leadingAnchor),
                button.trailingAnchor.constraint(equalTo: bannerView.trailingAnchor),
                button.bottomAnchor.constraint(equalTo: bannerView.bottomAnchor)
            ])
            
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: bannerView.topAnchor),
                imageView.leadingAnchor.constraint(equalTo: bannerView.leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: bannerView.trailingAnchor),
                imageView.bottomAnchor.constraint(equalTo: bannerView.bottomAnchor)
            ])
        }
    }
    
    private func initUI() {
        self.contentView.addSubview(emptyView)
        self.emptyView.addSubview(bannerScrollView)
        self.emptyView.addSubview(bannerPage)
        self.bannerScrollView.addSubview(bannerStackView)
    }
    
    private func initAttribute() {
        self.selectionStyle = .none
        
        NSLayoutConstraint.activate([
            emptyView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            emptyView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            emptyView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            emptyView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        NSLayoutConstraint.activate([
            bannerScrollView.topAnchor.constraint(equalTo: emptyView.topAnchor),
            bannerScrollView.leadingAnchor.constraint(equalTo: emptyView.leadingAnchor),
            bannerScrollView.trailingAnchor.constraint(equalTo: emptyView.trailingAnchor),
            bannerScrollView.bottomAnchor.constraint(equalTo: emptyView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            bannerStackView.topAnchor.constraint(equalTo: bannerScrollView.topAnchor),
            bannerStackView.leadingAnchor.constraint(equalTo: bannerScrollView.leadingAnchor),
            bannerStackView.trailingAnchor.constraint(equalTo: bannerScrollView.trailingAnchor),
            bannerStackView.bottomAnchor.constraint(equalTo: bannerScrollView.bottomAnchor),
            bannerStackView.heightAnchor.constraint(equalTo: bannerScrollView.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            bannerPage.trailingAnchor.constraint(equalTo: emptyView.trailingAnchor, constant: -12),
            bannerPage.bottomAnchor.constraint(equalTo: emptyView.bottomAnchor, constant: -12)
        ])
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let emptyView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let bannerScrollView : UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.isPagingEnabled = true
        return scroll
    }()
    
    let bannerStackView : UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        return stack
    }()
    
    let bannerPage : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = AppColor.neutral500.color
        button.setTitleColor(AppColor.white.color, for: .normal)
        button.titleLabel?.font = Typography.caption12Medium.font()
        button.titleLabel?.textAlignment = .center
        button.layer.cornerRadius = 999
        button.clipsToBounds = true
        return button
    }()
}
