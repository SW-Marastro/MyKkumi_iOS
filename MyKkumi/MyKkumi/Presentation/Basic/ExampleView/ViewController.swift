//
//  ViewController.swift
//  MyKkumi
//
//  Created by 최재혁 on 6/15/24.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    var viewModel : ViewModel!
    private let disposeBag = DisposeBag()
    
    private lazy var helloWord : UITextView = {
        let textView = UITextView()
        textView.text = "hello word"
        textView.textColor = .black
        textView.font = .systemFont(ofSize: 15.0)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        bindRx()
    }
    
    func bindRx() {
        viewModel = ViewModel()
        viewModel.helloWord
            .asObservable()
            .bind(to: helloWord.rx.text)
            .disposed(by: disposeBag)
        
        view.addSubview(helloWord)
        NSLayoutConstraint.activate([
            helloWord.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            helloWord.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            helloWord.widthAnchor.constraint(equalToConstant: 200),
            helloWord.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

