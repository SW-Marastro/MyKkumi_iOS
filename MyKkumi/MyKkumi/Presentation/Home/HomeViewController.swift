//
//  HomeViewController.swift
//  MyKkumi
//
//  Created by 최재혁 on 6/25/24.
//

import Foundation
import RxSwift

class HomeViewController : UIViewController {
    var viewModel : HomeViewModel
    private let disposeBag = DisposeBag()
    
    private lazy var hamburgurButton : UIButton = {
        let button = UIButton()
        button.isEnabled = true
        button.backgroundColor = .white
        button.setBackgroundImage(UIImage(named: "Hamburgur"), for: .normal)
        
        return button
    }()
    
    private lazy var searchText : UITextField = {
        let textfield = UITextField();
        textfield.frame = CGRect.zero
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.autocapitalizationType = .none
        textfield.autocorrectionType = .no
        textfield.placeholder = "마이구미 통합검색"
        textfield.clearButtonMode = .always
        textfield.clearsOnBeginEditing = false
        textfield.backgroundColor = Colors.GrayColor
        textfield.delegate = self
        
        return textfield
    }()
    
    private lazy var searchButton : UIButton = {
        let button = UIButton()
         button.isEnabled = true
         button.backgroundColor = .white
         button.setBackgroundImage(UIImage(named: "Search"), for: .normal)
         
         return button
     }()
    
    private lazy var notificationButton : UIButton = {
       let button = UIButton()
        button.isEnabled = true
        button.backgroundColor = .white
        button.setBackgroundImage(UIImage(named: "Notify"), for: .normal)
        
        return button
    }()
    
    private lazy var shoppingCartButton : UIButton = {
       let button = UIButton()
        button.isEnabled = true
        button.backgroundColor = .white
        button.setBackgroundImage(UIImage(named: "ShoppingCart"), for: .normal)
        
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension HomeViewController : UITextFieldDelegate {
    //return 버튼 눌리면 검색 API 호출하도록 수정해야함
    func textFieldShouldReturn(_ textField : UITextField) -> Bool {
        return true
    }
}
