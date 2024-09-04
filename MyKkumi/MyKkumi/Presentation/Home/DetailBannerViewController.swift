//
//  BannerViewController.swift
//  MyKkumi
//
//  Created by 최재혁 on 6/27/24.
//

import UIKit
import RxSwift
import RxCocoa

class DetailBannerViewController : BaseViewController<Void> {
    private lazy var bannerImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        //scaleAspectFill -> 비율 유지 + 화면 다 채움, scaleToFill -> 비울 깨지고 화면 다채움
        imageView.contentMode = .scaleAspectFit //비율 유지 하면서 화면 꽉 안채움
        return imageView
    }()
    
    let backButton : UIButton = {
        let backButton = UIButton(type: .custom)
        backButton.setImage(AppImage.back.image, for: .normal)
        return backButton
    }()
    
    init(banner: BannerVO) {
        super.init()
        self.bannerImageView.load(url: URL(string: banner.imageURL)!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        backButton.addTarget(self, action: #selector(popView), for: .touchUpInside)
        navigationItem.leftBarButtonItem = backBarButtonItem
    }
    
    public override func setupHierarchy() {
        view.addSubview(bannerImageView)
    }
    
    public override func setupLayout() {
        NSLayoutConstraint.activate([
            bannerImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bannerImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bannerImageView.topAnchor.constraint(equalTo: view.topAnchor),
            bannerImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc func popView() {
        self.navigationController?.popViewController(animated: true)
    }
}
