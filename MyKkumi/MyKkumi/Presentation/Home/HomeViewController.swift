import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class HomeViewController: BaseViewController {
    var viewModel: HomeViewModelProtocol!
    private var currentIndex = 0
    private var autoScrollTimer : Timer?
    private var bannerItem : [BannerVO] = []
    private var dataItems: [BannerVO] = []
    private var circularItems: [BannerVO] {
        var items: [BannerVO] = []
        if dataItems.count > 0 {
            let previousIndex = (currentIndex - 1 + dataItems.count) % dataItems.count
            let nextIndex = (currentIndex + 1) % dataItems.count

            items.append(dataItems[previousIndex])
            items.append(dataItems[currentIndex])
            items.append(dataItems[nextIndex])
        }
        return items
    }
    
    override public init() {
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAutoScroll()
        //self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    public override func setupHierarchy() {
        view.addSubview(hamburgurButton)
        view.addSubview(searchView)
        searchView.addSubview(searchText)
        searchView.addSubview(searchButton)
        view.addSubview(notificationButton)
        view.addSubview(shoppingCartButton)
        view.addSubview(banner)
        view.addSubview(bannerPage)
        view.addSubview(makePost)
    }
    
    public override func setupBind() {
        viewModel.banners
            .subscribe(onSuccess: { [weak self] banners in
                self?.dataItems = banners
                self?.bannerItem = self?.circularItems ?? []
                self?.currentIndex = 0
                self?.banner.reloadData()
                self!.updateIndex()
            })
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
        
        bannerPage.rx.tap
            .bind(to: viewModel.allBannerPageTap)
            .disposed(by: disposeBag)
        
        viewModel.shouldPushBannerView
            .drive (onNext : {[weak self] in
                let bannerInfoVC = BannerInfoViewController()
                bannerInfoVC.setupViewModel(viewModel: BannerInfoViewModel(bannerUseCase: injector.resolve(BannerUsecase.self)))
                bannerInfoVC.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(bannerInfoVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    public override func setupDelegate() {
        banner.delegate = self
        banner.dataSource = self
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
        guard !dataItems.isEmpty else { return }
        currentIndex = (currentIndex + 1) % dataItems.count
        bannerItem = circularItems
        banner.reloadData()
        banner.scrollToItem(at: IndexPath(item: 1, section: 0), at: .centeredHorizontally, animated: true)
        updatePageIndex(totalItems: dataItems.count)
    }
    
    public func setupViewModel(viewModel : HomeViewModelProtocol){
        self.viewModel = viewModel
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private lazy var hamburgurButton: UIButton = {
        let button = UIButton()
        button.isEnabled = true
        button.backgroundColor = .white
        button.setBackgroundImage(UIImage(named: "Hamburgur"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var searchView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Colors.GrayColor
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    private lazy var searchText: UITextField = {
        let textfield = UITextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.autocapitalizationType = .none
        textfield.autocorrectionType = .no
        textfield.placeholder = "마이구미 통합검색"
        textfield.clearButtonMode = .always
        textfield.clearsOnBeginEditing = false
        textfield.backgroundColor = Colors.GrayColor
        textfield.layer.cornerRadius = 8
        textfield.delegate = self
        return textfield
    }()
    
    private lazy var searchButton: UIButton = {
        let button = UIButton()
        button.isEnabled = true
        button.backgroundColor = .white
        button.setBackgroundImage(UIImage(named: "Search"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var notificationButton: UIButton = {
        let button = UIButton()
        button.isEnabled = true
        button.backgroundColor = .white
        button.setBackgroundImage(UIImage(named: "Notify"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var shoppingCartButton: UIButton = {
        let button = UIButton()
        button.isEnabled = true
        button.backgroundColor = .white
        button.setBackgroundImage(UIImage(named: "ShoppingCart"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var bannerPage : UIButton = {
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
    
    private lazy var makePost : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Colors.GrayColor
        button.setBackgroundImage(UIImage(named: "makePost"), for: .normal)
        return button
    }()
    
    public lazy var banner : BannerCollectionView = {
        let collectionView = BannerCollectionView(frame: CGRect.zero, collectionViewLayout: BannerCollectionViewFlowLayout())
        return collectionView
    }()
    
    public override func setupLayout() {
        // hamburgerButton Layout
        NSLayoutConstraint.activate([
            hamburgurButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            hamburgurButton.centerYAnchor.constraint(equalTo: searchView.centerYAnchor),
            hamburgurButton.widthAnchor.constraint(equalToConstant: 24),
            hamburgurButton.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        // searchView Layout
        NSLayoutConstraint.activate([
            searchView.leadingAnchor.constraint(equalTo: hamburgurButton.trailingAnchor, constant: 8),
            searchView.trailingAnchor.constraint(equalTo: notificationButton.leadingAnchor, constant: -8),
            searchView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            searchView.heightAnchor.constraint(equalToConstant: 36)
        ])
        
        // searchText Layout
        NSLayoutConstraint.activate([
            searchText.leadingAnchor.constraint(equalTo: searchButton.trailingAnchor, constant: 8),
            searchText.trailingAnchor.constraint(equalTo: searchView.trailingAnchor, constant: -8),
            searchText.topAnchor.constraint(equalTo: searchView.topAnchor, constant: 0),
            searchText.bottomAnchor.constraint(equalTo: searchView.bottomAnchor, constant: 0)
        ])
        
        // searchButton Layout
        NSLayoutConstraint.activate([
            searchButton.leadingAnchor.constraint(equalTo: searchView.leadingAnchor, constant: 8),
            searchButton.centerYAnchor.constraint(equalTo: searchView.centerYAnchor),
            searchButton.widthAnchor.constraint(equalToConstant: 24),
            searchButton.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        // notificationButton Layout
        NSLayoutConstraint.activate([
            notificationButton.trailingAnchor.constraint(equalTo: shoppingCartButton.leadingAnchor, constant: -8),
            notificationButton.centerYAnchor.constraint(equalTo: searchView.centerYAnchor),
            notificationButton.widthAnchor.constraint(equalToConstant: 24),
            notificationButton.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        // shoppingCart Layout
        NSLayoutConstraint.activate([
            shoppingCartButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            shoppingCartButton.centerYAnchor.constraint(equalTo: searchView.centerYAnchor),
            shoppingCartButton.widthAnchor.constraint(equalToConstant: 24),
            shoppingCartButton.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        //banner Layout
        NSLayoutConstraint.activate([
           banner.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
           banner.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
           banner.topAnchor.constraint(equalTo: searchView.bottomAnchor, constant: 16),
           banner.heightAnchor.constraint(equalToConstant: 120)
        ])
        
        //pageInfoLabel Layout
        NSLayoutConstraint.activate([
            bannerPage.trailingAnchor.constraint(equalTo: banner.trailingAnchor, constant: -8),
            bannerPage.bottomAnchor.constraint(equalTo: banner.bottomAnchor, constant: -8),
            bannerPage.widthAnchor.constraint(equalToConstant: 50),
            bannerPage.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        //makePost Layout
        NSLayoutConstraint.activate([
            makePost.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            makePost.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            makePost.heightAnchor.constraint(equalToConstant: 30),
            makePost.widthAnchor.constraint(equalToConstant: 30)
        ])
    }
}

extension HomeViewController: UITextFieldDelegate {
    // return 버튼 눌리면 검색 API 호출하도록 수정해야함
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 검색 API 호출 코드 추가
        return true
    }
}

extension HomeViewController : UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataItems.count
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCollectionCell.cellID, for: indexPath) as! BannerCollectionCell
        if(bannerItem.count > 0) {
            let bannerVO = bannerItem[indexPath.item]
            if let urlString = bannerVO.imageURL {
                cell.imageView.load(url: URL(string: urlString)!, placeholder: "placeholder")
            }
        }
        return cell
    }

    
    // 셀 크기를 CollectionView 크기와 동일하게 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
    //셀 수동으로 움직일시 currentIndex 조절
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: banner.contentOffset, size: banner.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        if let visibleIndexPath = banner.indexPathForItem(at: visiblePoint) {
            if visibleIndexPath.item == 0 {
                currentIndex = (currentIndex - 1 + dataItems.count) % dataItems.count
            } else if visibleIndexPath.item == 2 {
                currentIndex = (currentIndex + 1) % dataItems.count
            }
            bannerItem = circularItems
            banner.reloadData()
            banner.scrollToItem(at: IndexPath(item: 1, section: 0), at: .centeredHorizontally, animated: true)
            updatePageIndex(totalItems: dataItems.count)
        }
        setupAutoScroll()
    }

    
    private func updateIndex() {
        let visibleRect = CGRect(origin: banner.contentOffset, size: banner.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        if let visibleIndexPath = banner.indexPathForItem(at: visiblePoint) {
            currentIndex = visibleIndexPath.item
            updatePageIndex(totalItems: dataItems.count)
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        updatePageIndex(totalItems: dataItems.count)
    }
    
    private func updatePageIndex(totalItems : Int) {
        bannerPage.setTitle( "\(currentIndex + 1) / \(totalItems)", for: .normal)
    }
}


