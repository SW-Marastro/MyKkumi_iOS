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

class BannerInfoViewController : BaseViewController<BannerInfoViewModelProtocol> {
    var viewModel : BannerInfoViewModelProtocol!
    
    override public init() {
        super.init()
        self.banner.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public override func setupHierarchy() {
        view.addSubview(banner)
    }
    
    public override func setupBind(viewModel : BannerInfoViewModelProtocol) {
        self.viewModel = viewModel
        
        self.rx.viewDidLoad
            .bind(to: viewModel.viewDidLoad)
            .disposed(by: disposeBag)
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, BannerVO>>(configureCell: { (_, collectionView, indexPath, bannerVO) -> UICollectionViewCell in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCollectionCellVertical.cellID, for: indexPath) as! BannerCollectionCellVertical
            cell.imageView.load(url: URL(string: bannerVO.imageURL)!)
            return cell
        })
        
        viewModel.deliverBannerData
            .map { [SectionModel(model: "Section 1", items: $0)] }
            .asDriver(onErrorJustReturn: [])
            .drive(banner.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        banner.rx.modelSelected(BannerVO.self)
            .subscribe(onNext : {[weak self] bannerVO in
                self?.viewModel.bannerTap.onNext(bannerVO.id)
            })
            .disposed(by: disposeBag)
        
        viewModel.shouldPushDetailBanner
            .drive(onNext : {[weak self] bannerVO in
                let cellVC = DetailBannerViewController(banner: bannerVO)
                self?.navigationController?.pushViewController(cellVC, animated: true)
            })
            .disposed(by: disposeBag)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension BannerInfoViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: collectionView.bounds.width, height: 120)
        }
}
