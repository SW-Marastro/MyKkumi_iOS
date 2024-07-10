import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class HomeViewController: BaseViewController<HomeViewModelProtocol> {
    var viewModel: HomeViewModelProtocol!
    private var fetch : Bool = false
    private var posts : [PostVO] = []
    private var cursor : String?
    
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
        view.addSubview(makePost)
    }
    
    public override func setupBind(viewModel : HomeViewModelProtocol) {
        super.setupBind(viewModel: viewModel)
        
        self.viewModel = viewModel
        
        self.rx.viewDidLoad
            .bind(to: viewModel.viewdidload)
            .disposed(by: disposeBag)
        
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
        
        self.viewModel.showPostTableView
            .drive(onNext: { [weak self] postsVO in
                postsVO.posts.forEach {post in
                    self?.posts.append(post)
                }
                self?.cursor = postsVO.cursor
                self?.postTableView.reloadData()
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
    
    private lazy var makePost : UIButton = {
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
            makePost.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            makePost.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            makePost.heightAnchor.constraint(equalToConstant: 30),
            makePost.widthAnchor.constraint(equalToConstant: 30)
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
        return posts.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: HomeBannerCell.cellID, for: indexPath) as! HomeBannerCell
            
            viewModel.deliveryBannerDetailViewModel
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
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: PostTableCell.cellID, for: indexPath) as! PostTableCell
                cell.setCellData(postVO: posts[indexPath.section - 1])
                cell.selectionStyle = .none
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: PostTableCellOption.cellID, for: indexPath) as! PostTableCellOption
                cell.setCellData(postVO: posts[indexPath.section - 1])
                return cell
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.height
        {
            if !fetch && cursor != nil
            {
                beginFetch()
                fetch = false
            }
        }
    }
    
    func beginFetch() {
        fetch = true
        viewModel.getPostsData.onNext(cursor)
        postTableView.reloadData()
    }
}
