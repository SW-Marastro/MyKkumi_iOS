//
//  BannerViewController.swift
//  MyKkumi
//
//  Created by 최재혁 on 6/27/24.
//

import UIKit
import RxSwift
import RxCocoa

class BannerViewController : BaseViewController<Void> {
    var banner : BannerVO?
    
    private lazy var bannerImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        //scaleAspectFill -> 비율 유지 + 화면 다 채움, scaleToFill -> 비울 깨지고 화면 다채움
        imageView.contentMode = .scaleAspectFit //비율 유지 하면서 화면 꽉 안채움
        return imageView
    }()
    
    init(banner: BannerVO) {
        self.banner = banner
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    public override func setupBind(viewModel : Void) {
        super.setupBind(viewModel: viewModel)
        if let urlString = banner?.imageURL {
            bannerImageView.load(url: URL(string: urlString)!, placeholder: "placeholder")
        }
    }
}
