//
//  PostTableCell.swift
//  MyKkumi
//
//  Created by 최재혁 on 7/2/24.
//

import UIKit
import RxSwift

open class PostTableCell : UITableViewCell {
    public static let cellID = "PostTableCell"
    private let disposeBag = DisposeBag()
    private var images : [String] = []
    private var viewModel : PostCellViewModelProtocol!
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupHierarchy()
        initAttribute()
        setupLayout()
    }
    
    public func bind(viewModel : PostCellViewModelProtocol) {
        self.viewModel = viewModel
        
        optionButton.rx.tap
            .bind(to: viewModel.optionButtonTap)
            .disposed(by: disposeBag)
    }
    
    //관련 Data Binding
    public func setCellData(postVO : PostVO) {
        profileImageView.load(url: URL(string: postVO.writer.profileImage)!, placeholder: "placeholder")
        self.images = postVO.imageURLs
        postImageCollection.reloadData()
        updateCountLabel()
        nicknameLabel.text = postVO.writer.nickname
        categoryLabel.text = postVO.category + "-" + postVO.subCategory
    }
    
    func initAttribute() {
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        
        postImageCollection.delegate = self
        postImageCollection.dataSource = self
    }
    
    func setupHierarchy() {
        contentView.addSubview(mainStack)
        mainStack.addArrangedSubview(userProfileStack)
        mainStack.addArrangedSubview(postImageView)
        postImageView.addSubview(postImageCollection)
        postImageView.addSubview(countImageLabel)
        userProfileStack.addArrangedSubview(profileImageView)
        userProfileStack.addArrangedSubview(postInfoStack)
        userProfileStack.addArrangedSubview(optionButton)
        postInfoStack.addArrangedSubview(nicknameLabel)
        postInfoStack.addArrangedSubview(categoryLabel)
    }
    
    func setupLayout() {
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let mainStack : UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.alignment = .center
        return view
    }()
    
    let userProfileStack : UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.alignment = .leading
        return view
    }()
    
    let postInfoStack : UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.alignment = .leading
        view.spacing = 3
        return view
    }()
    
    let ButtonStack : UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints  = false
        view.axis = .horizontal
        return view
    }()
    
    let contentStack : UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints  = false
        view.axis = .vertical
        return view
    }()
    
    let postImageView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let profileImageView : UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.layer.masksToBounds = true
        return view
    }()
    
    let nicknameLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
    
    let categoryLabel : UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    let optionButton : UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "trheePoint"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let postImageCollection : PostImageCollectionView = {
        let collection = PostImageCollectionView(frame: CGRect.zero, collectionViewLayout: PostImageCollectionViewFlowLayout())
        
        return collection
    }()
    
    let countImageLabel : UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
}


open class PostTableCellOption : UITableViewCell {
    public static let cellID = "PostTableCellOption"
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupHierarchy()
        initAttribute()
        setupLayout()
    }
    
    public func setCellData(postVO : PostVO) {
        contentLabel.text = postVO.content
        contentLabel.text = postVO.writer.nickname + " " + postVO.content
        iconButtonStack.addArrangedSubview(like)
        iconButtonStack.addArrangedSubview(comment)
        iconButtonStack.addArrangedSubview(bookmark)
    }
    
    func initAttribute() {
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentLabel.font = UIFont.systemFont(ofSize: 17)
        contentLabel.textColor = .gray
    }
    
    func setupHierarchy() {
        contentView.addSubview(mainStack)
        mainStack.addArrangedSubview(iconButtonStack)
        iconButtonStack.addArrangedSubview(shareButton)
        mainStack.addArrangedSubview(contentLabel)
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            iconButtonStack.topAnchor.constraint(equalTo: mainStack.topAnchor),
            iconButtonStack.leadingAnchor.constraint(equalTo: mainStack.leadingAnchor),
            iconButtonStack.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor)
        ])
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let mainStack : UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .center
        view.spacing = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let iconButtonStack : UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let shareButton : UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "share"), for: .normal)
        return button
    }()
    
    let contentLabel = UILabel()
    
    let like = CountButton(image: "heart", text: "57")
    let comment = CountButton(image: "chat", text: "2")
    let bookmark = CountButton(image: "bookmark", text: "6")
}

extension PostTableCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostImageCollectionViewCell.cellID, for: indexPath) as! PostImageCollectionViewCell
        cell.imageView.load(url: URL(string: images[indexPath.item])!, placeholder: "placeholder")
        return cell
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updateCountLabel()
    }

    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        updateCountLabel()
    }
    
    private func updateCountLabel() {
        let visibleCells = postImageCollection.visibleCells
        guard let visibleCell = visibleCells.first else { return }
        guard let indexPath = postImageCollection.indexPath(for: visibleCell) else { return }
        
        let currentItem = indexPath.item + 1
        let totalItems = postImageCollection.numberOfItems(inSection: 0)
        countImageLabel.text = "\(currentItem) / \(totalItems)"
    }
}
