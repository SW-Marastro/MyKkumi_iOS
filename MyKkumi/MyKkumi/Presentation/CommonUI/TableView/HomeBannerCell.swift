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
    
    private var timer: Timer?
    private var currentPage = 0
    private var bannerData: [BannerVO] = []
    
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
        self.bannerData = [bannerData.last!] + bannerData + [bannerData.first!]
        
        for banner in self.bannerData {
            addBanner(banner)
        }
        
        // 첫 번째 페이지로 설정
        bannerScrollView.contentOffset = CGPoint(x: bannerScrollView.frame.width, y: 0)
        setupButtonLabel()
        startAutoScroll()
    }
    
    private func startAutoScroll() {
        stopAutoScroll()  // 기존 타이머를 멈춤
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(scrollToNextPage), userInfo: nil, repeats: true)
    }
        
    private func stopAutoScroll() {
        timer?.invalidate()
        timer = nil
    }
    
    private func setupButtonLabel() {
        self.bannerPage.setTitle("\(currentPage + 1)/\(self.bannerData.count-2)", for: .normal)
    }
    
    @objc private func scrollToNextPage() {
        guard !bannerData.isEmpty else { return }

        currentPage += 1
        let xOffset = CGFloat(currentPage + 1) * bannerScrollView.frame.width
        bannerScrollView.setContentOffset(CGPoint(x: xOffset, y: 0), animated: true)
    }
    
    private func initUI() {
        self.contentView.addSubview(emptyView)
        self.emptyView.addSubview(bannerScrollView)
        self.emptyView.addSubview(bannerPage)
        self.emptyView.bringSubviewToFront(bannerPage)
        self.bannerScrollView.addSubview(bannerStackView)
        bannerScrollView.delegate = self
    }
    
    private func initAttribute() {
        self.selectionStyle = .none
        
        NSLayoutConstraint.activate([
            emptyView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            emptyView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 12),
            emptyView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -12),
            emptyView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
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
            bannerPage.bottomAnchor.constraint(equalTo: emptyView.bottomAnchor, constant: -12),
            bannerPage.heightAnchor.constraint(equalToConstant: 20),
            bannerPage.widthAnchor.constraint(equalToConstant: 34)
        ])
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let emptyView : UIView = {
        let view = UIView()
        view.backgroundColor = AppColor.neutral50.color
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        return view
    }()
    
    let bannerScrollView : UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.isPagingEnabled = true
        scroll.layer.cornerRadius = 12
        scroll.showsHorizontalScrollIndicator = false
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
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        return button
    }()
    
    func addBanner(_ banner : BannerVO) {
        let bannerView : UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = AppColor.neutral50.color
            view.layer.cornerRadius = 12
            return view
        }()
        
        let button : UIButton = {
            let button = UIButton()
            button.tag = banner.id
            button.layer.cornerRadius = 12
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
        
        let imageView : UIImageView = {
            let image = UIImageView()
            image.translatesAutoresizingMaskIntoConstraints = false
            image.load(url: URL(string : banner.imageURL)!)
            image.layer.cornerRadius = 12
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
            bannerView.widthAnchor.constraint(equalTo: bannerScrollView.widthAnchor),
            bannerView.heightAnchor.constraint(equalTo: bannerScrollView.heightAnchor)
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

extension HomeBannerCell : UIScrollViewDelegate {
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentPage = Int(scrollView.contentOffset.x / scrollView.frame.width) - 1
        
        if currentPage == -1 {
            scrollView.setContentOffset(CGPoint(x: CGFloat(bannerData.count - 2) * scrollView.frame.width, y: 0), animated: false)
            currentPage = bannerData.count - 3
        } else if currentPage == bannerData.count - 2 {
            scrollView.setContentOffset(CGPoint(x: scrollView.frame.width, y: 0), animated: false)
            currentPage = 0
        }
        
        self.stopAutoScroll()
        self.startAutoScroll()
        self.setupButtonLabel()
    }

    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if currentPage == bannerData.count - 2 {
            scrollView.setContentOffset(CGPoint(x: scrollView.frame.width, y: 0), animated: false)
            currentPage = 0
        }
        self.setupButtonLabel()
    }
}
