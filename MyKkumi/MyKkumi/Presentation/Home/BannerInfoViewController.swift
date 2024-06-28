//
//  BannerInfoViewController.swift
//  MyKkumi
//
//  Created by 최재혁 on 6/28/24.
//

import Foundation
import RxSwift
import RxCocoa

class BannerInfoViewController : BaseViewController {
    var viewModel : HomeViewModelProtocol
    
    public lazy var banner : BannerCollectionView = {
        let collectionView = BannerCollectionView(frame: CGRect.zero, collectionViewLayout: BannerCollectionViewFlowLayoutVertical())
        return collectionView
    }()
    
    public init(viewModel : HomeViewModelProtocol) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchData()
    }
    
    public override func setupHierarchy() {
        view.addSubview(banner)
    }
    
    public override func setupLayout() {
        NSLayoutConstraint.activate([
            banner.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            banner.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            banner.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            banner.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
    
    public override func setupBind() {
        viewModel.banners
            .bind(to: banner.rx.items(cellIdentifier: BannerCollectionCellVertical.cellID, cellType: BannerCollectionCellVertical.self)) { row, bannerVO, cell in
                if let urlString = bannerVO.imageURL {
                    cell.imageView.load(url: URL(string: urlString)!, placeholder: "placeholder")
                }
            }
            .disposed(by: disposeBag)
        
        banner.rx.modelSelected(BannerVO.self)
            .subscribe(onNext : {[weak self] bannerVO in
                if let id = bannerVO.id {
                    self?.viewModel.bannerTap.onNext(id)
                }
            })
            .disposed(by: disposeBag)
        
//        viewModel.bannerData
//            .subscribe(onNext : {[weak self] result in
//                switch result {
//                case .success(let bannerVO):
//                    let cellVC = BannerViewController(banner: bannerVO)
//                    self?.navigationController?.pushViewController(cellVC, animated: true)
//                case .failure(let error):
//                    print("Error: \(error)")
//                }
//            })
//            .disposed(by: disposeBag)
    }
    
    override func setupDelegate() {
        banner.delegate = self
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
