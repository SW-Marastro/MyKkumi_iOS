import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class HomeViewController: BaseViewController<HomeViewModelProtocol> {
    var viewModel: HomeViewModelProtocol!
    private var fetch : Bool = false
    
    override init() {
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    public override func setupHierarchy() {
        view.addSubview(hamburgurButton)
        view.addSubview(searchView)
        searchView.addSubview(searchText)
        searchView.addSubview(searchButton)
        view.addSubview(notificationButton)
        view.addSubview(shoppingCartButton)
        view.addSubview(postTableView)
        view.addSubview(upLoadPostButton)
    }
    
    public override func setupBind(viewModel : HomeViewModelProtocol) {
        super.setupBind(viewModel: viewModel)
        
        self.viewModel = viewModel
        
        self.rx.viewDidLoad
            .bind(to: viewModel.viewdidload)
            .disposed(by: disposeBag)
        
        //MARK: BannerBinding
        viewModel.bannerDataOutput
            .emit()
            .disposed(by: disposeBag)
        
        self.viewModel.shouldPushBannerInfoView
            .drive (onNext : {[weak self] in
                let bannerInfoVC = BannerInfoViewController()
                bannerInfoVC.setupBind(viewModel: BannerInfoViewModel())
                bannerInfoVC.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(bannerInfoVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        self.viewModel.shouldPushBannerView
            .drive(onNext : {[weak self] bannerVO in
                let cellVC = DetailBannerViewController(banner: bannerVO)
                self?.navigationController?.pushViewController(cellVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        //MARK: PostBinding
        self.viewModel.getPostsData
            .onNext(nil)
        
        self.viewModel.postObserve
            .subscribe(onNext : { post in
                self.viewModel.postRelay
                    .accept(post)
            })
            .disposed(by: disposeBag)
        
        self.viewModel.deliverPost
            .drive()
            .disposed(by: disposeBag)
        
        self.viewModel.deliverPostCount
            .drive()
            .disposed(by: disposeBag)
        
        self.viewModel.deliverCursor
            .drive()
            .disposed(by: disposeBag)
        
        self.viewModel.showPostTableView
            .drive(onNext: { [weak self] _ in
                self?.postTableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        self.upLoadPostButton.rx.tap
            .bind(to: viewModel.uploadPostButtonTap)
            .disposed(by: disposeBag)
        
        self.viewModel.shouldPushUploadPostView
            .drive(onNext: {[weak self] _ in
                let authVC = AuthViewController()
                authVC.setupBind(viewModel: AuthViewModel())
                authVC.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(authVC, animated: true)
            })
            .disposed(by: disposeBag)
        
    }
    
    public override func setupDelegate() {
        postTableView.delegate = self
        postTableView.dataSource = self
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
    
    private lazy var upLoadPostButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Colors.GrayColor
        button.setBackgroundImage(UIImage(named: "makePost"), for: .normal)
        return button
    }()
    
    public lazy var postTableView : PostTableView = {
        let tableView = PostTableView()
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
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
        
        //makePost Layout
        NSLayoutConstraint.activate([
            upLoadPostButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            upLoadPostButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            upLoadPostButton.heightAnchor.constraint(equalToConstant: 30),
            upLoadPostButton.widthAnchor.constraint(equalToConstant: 30)
        ])
        
        //PostTable Layout
        NSLayoutConstraint.activate([
            postTableView.topAnchor.constraint(equalTo: searchView.bottomAnchor, constant: 10),
            postTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            postTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 0),
            postTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
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

extension HomeViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else {
            var count : Int = 0
            
            viewModel.deliverPostCount
                .drive(onNext : { postCount in
                    count = postCount
                })
                .disposed(by: disposeBag)
            
            return count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: HomeBannerCell.cellID, for: indexPath) as! HomeBannerCell
            
            viewModel.deliverBannerDetailViewModel
                .emit(onNext: { viewModel in
                    cell.bind(viewModel: viewModel)
                })
                .disposed(by: disposeBag)
            
            viewModel.bannerDataOutput
                .emit(onNext : { banners in
                    cell.setCellData(bannerData: banners)
                })
                .disposed(by: disposeBag)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: PostTableCell.cellID, for: indexPath) as! PostTableCell
            
            viewModel.getPost
                .onNext(indexPath.row)
            
            viewModel.deliverPost
                .drive(onNext: { postVO in
                    cell.setCellData(postVO: postVO)
                })
                .disposed(by: disposeBag)
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func beginFetch( _ cursur : String?) {
        let cursur = cursur
        viewModel.getPostsData
            .onNext(cursur)
            
        postTableView.reloadData()
        fetch = true
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let sectionIndex = tableView.numberOfSections - 1
        let lastRow = tableView.numberOfRows(inSection: sectionIndex) - 1
        
        if indexPath.section == sectionIndex && indexPath.row == lastRow {
            var viewCursur : String = ""
            viewModel.deliverCursor
                .drive(onNext: { cursor in
                    if cursor != "" {
                        viewCursur = cursor!
                    }
                })
                .disposed(by: disposeBag)
            
            if viewCursur != "" && !fetch {
                beginFetch(viewCursur)
                fetch = false
            }
        }
    }
}
