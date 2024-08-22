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
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    public override func setupHierarchy() {
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backBarButtonItem
        navigationItem.titleView = navTitle
        
        view.addSubview(bannerScrollView)
        bannerScrollView.addSubview(bannerStackView)
    }
    
    public override func setupBind(viewModel : BannerInfoViewModelProtocol) {
        self.viewModel = viewModel
        
        self.rx.viewDidLoad
            .bind(to: viewModel.viewDidLoad)
            .disposed(by: disposeBag)
        
        self.viewModel.shouldDrawBanner
            .drive(onNext: {[weak self] banners in
                guard let self = self else { return }
                for banner in banners {
                    addBanner(banner)
                }
            })
            .disposed(by: disposeBag)
        
        self.backButton.rx.tap
            .bind(to: viewModel.backButtonTap)
            .disposed(by: disposeBag)
        
        self.viewModel.shouldPopView
            .drive(onNext: {[weak self] _ in
                guard let self = self else { return }
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    public override func setupLayout() {
        NSLayoutConstraint.activate([
            bannerScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            bannerScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            bannerScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            bannerScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            bannerStackView.topAnchor.constraint(equalTo: bannerScrollView.topAnchor),
            bannerStackView.leadingAnchor.constraint(equalTo: bannerScrollView.leadingAnchor),
            bannerStackView.trailingAnchor.constraint(equalTo: bannerScrollView.trailingAnchor),
            bannerStackView.bottomAnchor.constraint(equalTo: bannerScrollView.bottomAnchor),
            bannerStackView.widthAnchor.constraint(equalTo: bannerScrollView.widthAnchor)
        ])
    }
    
    public lazy var bannerScrollView : UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.showsVerticalScrollIndicator = false
        return scroll
    }()
    
    let bannerStackView : UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 12
        return stack
    }()
    
    // 커스텀 Back 버튼
    let backButton : UIButton = {
        let backButton = UIButton(type: .custom)
        backButton.setImage(AppImage.back.image, for: .normal)
        return backButton
    }()
    
    let navTitle : UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "이벤트", attributes: Typography.heading18Bold(color: AppColor.neutral900).attributes)
        return label
    }()
    
    func addBanner(_ banner : BannerVO) {
        let bannerView : UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = AppColor.neutral50.color
            view.layer.cornerRadius = 12
            view.clipsToBounds = true
            return view
        }()
        
        let button : UIButton = {
            let button = UIButton()
            button.tag = banner.id
            button.layer.cornerRadius = 12
            button.translatesAutoresizingMaskIntoConstraints = false
            button.clipsToBounds = true
            return button
        }()
        
        let imageView : UIImageView = {
            let image = UIImageView()
            image.translatesAutoresizingMaskIntoConstraints = false
            image.load(url: URL(string : banner.imageURL)!)
            image.layer.cornerRadius = 12
            image.clipsToBounds = true
            return image
        }()
        
        button.rx.tap
            .map{ button.tag }
            .subscribe(onNext: {[weak self] tag in
                guard let self = self else { return }
                self.viewModel.bannerTap.onNext(tag)
            })
            .disposed(by: disposeBag)

        bannerView.addSubview(button)
        bannerView.addSubview(imageView)
        
        bannerStackView.addArrangedSubview(bannerView)
        
        NSLayoutConstraint.activate([
            bannerView.widthAnchor.constraint(equalTo: bannerScrollView.widthAnchor),
            bannerView.heightAnchor.constraint(equalToConstant: (bannerScrollView.frame.height-60) / 6.5)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

