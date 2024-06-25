//
//  ViewController.swift
//  MyKkumi
//
//  Created by 최재혁 on 6/15/24.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    var viewModel : ViewModel
    private let disposeBag = DisposeBag()
    
    private lazy var helloWord : UILabel = {
        let textView = UILabel()
        textView.text = "before taps"
        textView.textColor = .black
        textView.font = .systemFont(ofSize: 15.0)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private lazy var hellowordButton : UIButton = {
        let button = UIButton()
        button.isEnabled = true
        button.backgroundColor = .blue
        button.setTitle("Hello", for : .normal)
        button.setTitleColor(.red, for: .normal)
        button.layer.cornerRadius = 10
        
        return button
    }()

    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        bindRx()
    }
    
    func bindRx() {
        viewModel.helloWord
            .asObservable()
            .bind(to: helloWord.rx.text)
            .disposed(by: disposeBag)
        
        hellowordButton.rx.tap
            .bind(to: self.viewModel.buttontaps)
            .disposed(by: disposeBag)
        
        view.addSubview(helloWord)
        view.addSubview(hellowordButton)
        
        //기본 설정 무시
        helloWord.translatesAutoresizingMaskIntoConstraints = false
        hellowordButton.translatesAutoresizingMaskIntoConstraints = false
        
        //helloWord NSLaout 설정
        NSLayoutConstraint.activate ([
            helloWord.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            helloWord.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -30),
            helloWord.widthAnchor.constraint(equalToConstant: 200),
            helloWord.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        //Button NSLaout 설정
        NSLayoutConstraint.activate([
            hellowordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            hellowordButton.centerYAnchor.constraint(equalTo: helloWord.bottomAnchor, constant: 20),
            hellowordButton.widthAnchor.constraint(equalToConstant: 200),
            hellowordButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

