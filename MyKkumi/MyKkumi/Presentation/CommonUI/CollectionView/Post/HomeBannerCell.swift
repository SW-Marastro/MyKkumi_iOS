//
//  HomeBannerCell.swift
//  MyKkumi
//
//  Created by 최재혁 on 7/5/24.
//

import UIKit
import RxSwift

open class HomeBannerCell : UITableViewCell {
    public static let cellID = "HomeBannerCell"
    private var bannerData : [BannerVO] = []
    private var currentIndex = 0
    private var autoScrollTimer : Timer?
    private var disposeBag = DisposeBag()
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initUI()
        initAttribute()
        setupDelegate()
    }
    
    private func initAttribute() {
        self.selectionStyle = .none
        NSLayoutConstraint.activate([
           mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
           mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
           mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
           mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
           mainStack.heightAnchor.constraint(equalToConstant: 120)
       ])
        
        NSLayoutConstraint.activate([
           emptyView.leadingAnchor.constraint(equalTo: mainStack.leadingAnchor, constant: 0),
           emptyView.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor, constant: 0),
           emptyView.topAnchor.constraint(equalTo: mainStack.topAnchor, constant: 0),
           emptyView.bottomAnchor.constraint(equalTo: mainStack.bottomAnchor, constant: 0),
           emptyView.heightAnchor.constraint(equalTo: mainStack.heightAnchor)
       ])
        
        //banner Layout
        NSLayoutConstraint.activate([
           banner.leadingAnchor.constraint(equalTo: mainStack.leadingAnchor, constant: 16),
           banner.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor, constant: -16),
           banner.topAnchor.constraint(equalTo: mainStack.topAnchor),
           banner.bottomAnchor.constraint(equalTo: mainStack.bottomAnchor, constant: -8),
        ])
        
        //pageInfoLabel Layout
        NSLayoutConstraint.activate([
            bannerPage.trailingAnchor.constraint(equalTo: banner.trailingAnchor, constant: -8),
            bannerPage.bottomAnchor.constraint(equalTo: banner.bottomAnchor, constant: -8),
            bannerPage.widthAnchor.constraint(equalToConstant: 50),
            bannerPage.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    public func bind(viewModel : HomeViewModelProtocol, bannerData : [BannerVO]) {
        self.bannerData = bannerData
        banner.rx.modelSelected(BannerVO.self)
            .subscribe(onNext : {bannerVO in
                if let id = bannerVO.id {
                    viewModel.bannerTap.onNext(id)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.shouldPushBannerView
            .drive(onNext : {[weak self] bannerVO in
                guard let strongSelf = self, let parentVC = strongSelf.parentViewController() else { return }
                let cellVC = BannerViewController(banner: bannerVO)
                parentVC.navigationController?.pushViewController(cellVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        bannerPage.rx.tap
            .bind(to: viewModel.allBannerPageTap)
            .disposed(by: disposeBag)
        
        viewModel.shouldPushBannerInfoView
            .drive (onNext : {[weak self] in
                guard let strongSelf = self, let parentVC = strongSelf.parentViewController() else { return }
                let bannerInfoVC = BannerInfoViewController()
                bannerInfoVC.setupBind(viewModel: BannerInfoViewModel())
                bannerInfoVC.hidesBottomBarWhenPushed = true
                parentVC.navigationController?.pushViewController(bannerInfoVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func initUI() {
        contentView.addSubview(mainStack)
        mainStack.addArrangedSubview(emptyView)
        emptyView.addSubview(banner)
        emptyView.addSubview(bannerPage)
        emptyView.bringSubviewToFront(bannerPage)
    }
    
    private func setupDelegate() {
        banner.delegate = self
        banner.dataSource = self
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let mainStack: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.alignment = .center
        
        return view
    }()
    
    let emptyView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let banner : BannerCollectionView = {
        let collectionView = BannerCollectionView(frame: CGRect.zero, collectionViewLayout: BannerCollectionViewFlowLayout())
        return collectionView
    }()
    
    let bannerPage : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(white: 0, alpha: 0.5)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.titleLabel?.textAlignment = .center
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        return button
    }()
}

extension HomeBannerCell : UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, UICollectionViewDataSource {
    // 셀 크기를 CollectionView 크기와 동일하게 설정
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    //셀 수동으로 움직일시 currentIndex 조절
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updateIndex()
        setupAutoScroll()
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bannerData.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = banner.dequeueReusableCell(withReuseIdentifier: BannerCollectionCell.cellID, for: indexPath) as! BannerCollectionCell
        cell.imageView.load(url: URL(string : bannerData[indexPath.row].imageURL!)!, placeholder: "placeholder")
        return cell
    }
    
    private func updateIndex() {
        let visibleRect = CGRect(origin: banner.contentOffset, size: banner.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        if let visibleIndexPath = banner.indexPathForItem(at: visiblePoint) {
            currentIndex = visibleIndexPath.item
            updatePageIndex(totalItems: banner.numberOfItems(inSection: 0))
        }
    }
    
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        updateIndex()
    }
    
    private func updatePageIndex(totalItems : Int) {
        bannerPage.setTitle( "\(currentIndex + 1) / \(totalItems)", for: .normal)
    }
    
    private func setupAutoScroll() {
        stopAutoScrollTimer()
        autoScrollTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) {(Timer) in
            self.moveToNextCell()}
    }
    
    private func stopAutoScrollTimer() {
        autoScrollTimer?.invalidate()
        autoScrollTimer = nil
    }
    
    private func moveToNextCell() {
        let itemCount = banner.numberOfItems(inSection: 0)
        if itemCount == 0 { return }
        currentIndex = (currentIndex + 1) % itemCount
        let indexPath = IndexPath(item: currentIndex, section: 0)
        banner.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}

extension UIView {
    func parentViewController() -> UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder?.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
