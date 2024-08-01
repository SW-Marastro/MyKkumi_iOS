//
//  SelectedImageCell.swift
//  MyKkumi
//
//  Created by 최재혁 on 7/31/24.
//

import UIKit
import RxSwift

open class SelectedImageCell : UICollectionViewCell {
    public static let cellID = "SelectedImageCell"
    var imageView : UIImageView = UIImageView()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initAtrribute()
        initUI()
    }
    
    private func initAtrribute() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func initUI() {
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

open class AddImageCell : UICollectionViewCell {
    public static let cellID = "AddImageCell"
    var disposedBag = DisposeBag()
    var viewModel : AddImageViewModelProtocol!
    var addImageButton : UIButton = UIButton()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initAtrribute()
        initUI()
    }
    
    public func setBind(viewModel : AddImageViewModelProtocol) {
        self.viewModel = viewModel
        
        addImageButton.rx.tap
            .bind(to: viewModel.addButtonTap)
            .disposed(by: disposedBag)
    }
    
    private func initAtrribute() {
        addImageButton.translatesAutoresizingMaskIntoConstraints = false
        addImageButton.setBackgroundImage(UIImage(named: "chat"), for: .normal)
    }
    
    private func initUI() {
        contentView.addSubview(addImageButton)
        NSLayoutConstraint.activate([
            addImageButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            addImageButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            addImageButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            addImageButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
