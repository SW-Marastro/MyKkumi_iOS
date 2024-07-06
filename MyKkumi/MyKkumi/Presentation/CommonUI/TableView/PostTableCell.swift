//
//  PostTableCell.swift
//  MyKkumi
//
//  Created by 최재혁 on 7/2/24.
//

import UIKit

open class PostTableCell : UITableViewCell {
    public static let cellID = "PostTableCell"
    private var images : [String] = []
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initAttribute()
        setupHierarchy()
        setupLayout()
    }
    
    //관련 Data Binding
    public func bind(postVO : PostVO) {
        if let urlString = postVO.writer?.profileImage {
            profileImageView.load(url: URL(string: urlString)!, placeholder: "placeholder")
        }
        self.images = postVO.imageURL!
        postImageCollection.reloadData()
        updateCountLabel()
        categoryLabel.text = postVO.category! + "-" + postVO.subCategory!
    }
    
    func initAttribute() {
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        nicknameLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        optionButton.translatesAutoresizingMaskIntoConstraints = false
        countImageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        
        nicknameLabel.font = UIFont.boldSystemFont(ofSize:17)
        categoryLabel.font = UIFont.systemFont(ofSize: 17)
        
        optionButton.setBackgroundImage(UIImage(named: "threePoint"), for: .normal)
        
        postImageCollection.delegate = self
        postImageCollection.dataSource = self
    }
    
    func setupHierarchy() {
        contentView.addSubview(mainStack)
        mainStack.addArrangedSubview(userProfileStack)
        mainStack.addArrangedSubview(postInfoStack)
        postInfoStack.addArrangedSubview(postImageView)
        postImageView.addSubview(postImageCollection)
        postImageView.addSubview(countImageLabel)
        userProfileStack.addArrangedSubview(postInfoStack)
        userProfileStack.addArrangedSubview(optionButton)
        postInfoStack.addArrangedSubview(nicknameLabel)
        postInfoStack.addArrangedSubview(categoryLabel)
    }
    
    func setupLayout() {
        //mainStack
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        //userProfileStack
        NSLayoutConstraint.activate([
            userProfileStack.topAnchor.constraint(equalTo: mainStack.topAnchor),
            userProfileStack.leadingAnchor.constraint(equalTo: mainStack.leadingAnchor),
            userProfileStack.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor)
        ])
        
        //postImageStack
        NSLayoutConstraint.activate([
            postImageStack.topAnchor.constraint(equalTo: userProfileStack.bottomAnchor, constant: 5),
            postImageStack.leadingAnchor.constraint(equalTo: mainStack.leadingAnchor),
            postImageStack.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor),
            postImageStack.bottomAnchor.constraint(equalTo: mainStack.bottomAnchor),
        ])
        
        //profileImageView
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: userProfileStack.topAnchor),
            profileImageView.leadingAnchor.constraint(equalTo: userProfileStack.leadingAnchor, constant: 16),
            profileImageView.widthAnchor.constraint(equalTo: postInfoStack.heightAnchor),
            profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor)
        ])
        
        //postInfoStack
        NSLayoutConstraint.activate([
            postInfoStack.topAnchor.constraint(equalTo: userProfileStack.topAnchor),
            postInfoStack.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 4)
        ])
        
        //optionButton
        NSLayoutConstraint.activate([
            optionButton.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor, constant: -16)
        ])
        
        //emptyView
        NSLayoutConstraint.activate([
            postImageView.topAnchor.constraint(equalTo: postInfoStack.topAnchor),
            postImageView.leadingAnchor.constraint(equalTo: postInfoStack.leadingAnchor),
            postImageView.trailingAnchor.constraint(equalTo: postInfoStack.trailingAnchor),
            postImageView.bottomAnchor.constraint(equalTo: postInfoStack.bottomAnchor)
        ])
        
        //postImageCollection
        NSLayoutConstraint.activate([
            postImageCollection.topAnchor.constraint(equalTo: postImageView.topAnchor),
            postImageCollection.leadingAnchor.constraint(equalTo: postImageView.leadingAnchor),
            postImageCollection.trailingAnchor.constraint(equalTo: postImageView.trailingAnchor),
            postImageCollection.bottomAnchor.constraint(equalTo: postImageView.bottomAnchor)
        ])
        
        //countImageLavel
        NSLayoutConstraint.activate([
            countImageLabel.topAnchor.constraint(equalTo: postImageCollection.topAnchor, constant: 5),
            countImageLabel.trailingAnchor.constraint(equalTo: postImageCollection.trailingAnchor, constant: -5)
        ])
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
    
    let postImageStack : UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.alignment = .center
        return view
    }()
    
    let postImageView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let profileImageView = UIImageView()
    let nicknameLabel = UILabel()
    let categoryLabel = UILabel()
    let optionButton = UIButton()
    let postImageCollection = PostImageCollectionView(frame: CGRect.zero, collectionViewLayout: PostImageCollectionViewFlowLayout())
    let countImageLabel = UILabel()
}


open class PostTableCellOption : UITableViewCell {
    public static let cellID = "PostTableCellOption"
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initAttribute()
        setupHierarchy()
        setupLayout()
    }
    
    public func bind(postVO : PostVO) {
        contentLabel.text = postVO.content!
        let like = CountButton(image: "heart", text: "57")
        let comment = CountButton(image: "chat", text: "2")
        let bookmark = CountButton(image: "bookmark", text: "6")
        contentLabel.text = postVO.writer!.nickname! + postVO.content!
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
            iconButtonStack.leadingAnchor.constraint(equalTo: mainStack.leadingAnchor, constant: 6),
            iconButtonStack.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor, constant: -6)
        ])
        
        NSLayoutConstraint.activate([
            shareButton.trailingAnchor.constraint(equalTo: iconButtonStack.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            contentLabel.topAnchor.constraint(equalTo: iconButtonStack.bottomAnchor),
            contentLabel.leadingAnchor.constraint(equalTo: iconButtonStack.leadingAnchor),
            contentLabel.trailingAnchor.constraint(equalTo: iconButtonStack.trailingAnchor)
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
