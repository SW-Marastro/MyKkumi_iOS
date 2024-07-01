//
//  BannerInfoViewController.swift
//  MyKkumi
//
//  Created by 최재혁 on 6/28/24.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

class BannerInfoViewController : BaseViewController {
    var viewModel : BannerInfoViewModelProtocol!
    
    override public init() {
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public override func setupHierarchy() {
        view.addSubview(banner)
    }
    
    public override func setupBind() {
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, BannerVO>>(configureCell: { (_, collectionView, indexPath, bannerVO) -> UICollectionViewCell in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCollectionCellVertical.cellID, for: indexPath) as! BannerCollectionCellVertical
            if let urlString = bannerVO.imageURL {
                cell.imageView.load(url: URL(string: urlString)!, placeholder: "placeholder")
            }
            return cell
        })
        viewModel.banners
            .map { [SectionModel(model: "Section 1", items: $0)] }
            .asDriver(onErrorJustReturn: [])
            .drive(banner.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        banner.rx.modelSelected(BannerVO.self)
            .subscribe(onNext : {[weak self] bannerVO in
                if let id = bannerVO.id {
                    self?.viewModel.bannerTap.onNext(id)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.bannerPageData
            .drive(onNext : {[weak self] bannerVO in
                let cellVC = BannerViewController(banner: bannerVO)
                self?.navigationController?.pushViewController(cellVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    override func setupDelegate() {
        banner.delegate = self
    }
    
    public override func setupLayout() {
        NSLayoutConstraint.activate([
            banner.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            banner.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            banner.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            banner.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
    
    public lazy var banner : BannerCollectionView = {
        let collectionView = BannerCollectionView(frame: CGRect.zero, collectionViewLayout: BannerCollectionViewFlowLayoutVertical())
        return collectionView
    }()
    
    func setupViewModel(viewModel : BannerInfoViewModelProtocol) {
        self.viewModel = viewModel
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension BannerInfoViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: collectionView.bounds.width, height: 120)
        }
}
