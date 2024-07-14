//
//  AuthViewController.swift
//  MyKkumi
//
//  Created by 최재혁 on 7/10/24.
//

import Foundation
import RxSwift
import UIKit

class AuthViewController : BaseViewController<AuthViewModelProtocol>{
    var viewModel: AuthViewModelProtocol!
    
    override init() {
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public override func setupHierarchy() {
        view.addSubview(kakaoButton)
        view.addSubview(appleButton)
    }
    
    public override func setupBind(viewModel: AuthViewModelProtocol){
        self.viewModel = viewModel
    }
    
    public override func setupLayout() {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private var kakaoButton: UIButton = {
        let button = UIButton()
        button.setTitle("카카오 로그인", for: .normal)
        button.backgroundColor = .yellow
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var appleButton: UIButton = {
        let button = UIButton()
        button.setTitle("Apple ID로그인", for: .normal)
        button.backgroundColor = .gray
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
}
