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
    private var currentIndex = 0
    private var autoScrollTimer : Timer?
    private var disposeBag = DisposeBag()
    var viewModel : BannerCellViewModelProtocol!
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initUI()
        initAttribute()
        setupDelegate()
    }
    
    public func bind(viewModel : BannerCellViewModelProtocol) {
        self.viewModel = viewModel
        
        banner.rx.modelSelected(BannerVO.self)
            .subscribe(onNext: { bannerVO in
                viewModel.bannerTap.onNext(bannerVO.id)
            })
            .disposed(by: disposeBag)
        
        bannerPage.rx.tap
            .bind(to: viewModel.allBannerPageTap)
            .disposed(by: disposeBag)
    }
    
    public func setCellData(bannerData : [BannerVO]) {
        banner.dataSource = nil
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, BannerVO>>(configureCell: { (_, collectionView, indexPath, bannerVO) -> UICollectionViewCell in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCollectionCellVertical.cellID, for: indexPath) as! BannerCollectionCellVertical
            cell.imageView.load(url: URL(string: bannerVO.imageURL)!, placeholder: "placeholder")
            return cell
        })
        
        Observable.just(bannerData)
            .map { [SectionModel(model: "Section 1", items: $0)] }
            .asDriver(onErrorJustReturn: [])
            .drive(banner.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        setupAutoScroll()
        updateIndex()
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
    }
    
    private func initAttribute() {
        self.selectionStyle = .none
        
        // mainStack 제약 조건
       NSLayoutConstraint.activate([
           mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
           mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
           mainStack.topAnchor.constraint(equalTo: contentView.topAnchor),
           mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
       ])
       
       // emptyView 제약 조건
       NSLayoutConstraint.activate([
           emptyView.leadingAnchor.constraint(equalTo: mainStack.leadingAnchor),
           emptyView.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor),
           emptyView.heightAnchor.constraint(equalToConstant: 128) // 높이 설정
       ])
       
       // banner 제약 조건
       NSLayoutConstraint.activate([
           banner.leadingAnchor.constraint(equalTo: emptyView.leadingAnchor, constant: 16),
           banner.trailingAnchor.constraint(equalTo: emptyView.trailingAnchor, constant: -16),
           banner.topAnchor.constraint(equalTo: emptyView.topAnchor),
           banner.bottomAnchor.constraint(equalTo: emptyView.bottomAnchor, constant: -8)
       ])
       
       // bannerPage 제약 조건
       NSLayoutConstraint.activate([
           bannerPage.trailingAnchor.constraint(equalTo: banner.trailingAnchor, constant: -8),
           bannerPage.bottomAnchor.constraint(equalTo: banner.bottomAnchor, constant: -8),
           bannerPage.widthAnchor.constraint(equalToConstant: 50),
           bannerPage.heightAnchor.constraint(equalToConstant: 24)
       ])
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
        collectionView.layer.cornerRadius = 10
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

extension HomeBannerCell : UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    // 셀 크기를 CollectionView 크기와 동일하게 설정
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    //셀 수동으로 움직일시 currentIndex 조절
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updateIndex()
        setupAutoScroll()
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
