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
        
        
        self.viewModel.shouldReloadPostTable
            .emit(onNext: { [weak self] _ in
                self?.postTableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        self.upLoadPostButton.rx.tap
            .bind(to: viewModel.uploadPostButtonTap)
            .disposed(by: disposeBag)
        
        self.viewModel.shouldPushUploadPostView
            .drive(onNext : {[weak self] _ in
                let makePostVC = MakePostViewController()
                makePostVC.setupBind(viewModel: MakePostViewModel())
                makePostVC.hidesBottomBarWhenPushed  = true
                self?.navigationController?.pushViewController(makePostVC, animated: true)
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
    
    public override func setupLayout() {
        
    }
    
    private lazy var searchView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = AppColor.neutral100.color
        view.layer.cornerRadius = 10
        
        return view
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
    
    private lazy var upLoadPostButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = AppColor.neutral100.color
        button.setBackgroundImage(UIImage(named: "makePost"), for: .normal)
        return button
    }()
    
    public lazy var postTableView : PostTableView = {
        let tableView = PostTableView()
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
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
            return viewModel.postViewModels.value.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: HomeBannerCell.cellID, for: indexPath) as! HomeBannerCell
            
            viewModel.deliverBannerViewModel
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
            cell.bind(viewModel: viewModel.postViewModels.value[indexPath.row])
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
            
        }
    }
}
