import UIKit
import RxSwift

class HomeViewController: UIViewController {
    var viewModel: HomeViewModelProtocol
    private let disposeBag = DisposeBag()
    
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
    
    public init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        layout()
    }
    
    func layout() {
        view.addSubview(hamburgurButton)
        view.addSubview(searchView)
        searchView.addSubview(searchText)
        searchView.addSubview(searchButton)
        view.addSubview(notificationButton)
        view.addSubview(shoppingCartButton)
        
        // MARK: Layout
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension HomeViewController: UITextFieldDelegate {
    // return 버튼 눌리면 검색 API 호출하도록 수정해야함
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 검색 API 호출 코드 추가
        return true
    }
}
